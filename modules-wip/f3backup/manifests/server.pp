class f3backup::server (
    # Name for the client resources to realize
    $backup_server = 'default',
    # Home directory of the backup user
    $backup_home = '/backup',
    # Main f3backup.ini options
    $threads = '5',
    $lognameprefix = '%Y%m%d-',
    $backup_rdiff = true,
    $backup_mysql = false,
    $backup_command = false,
    $rdiff_global_exclude_file = '/etc/f3backup-exclude.txt, /backup/f3backup/%server%/exclude.txt',
    $rdiff_user = 'root',
    $rdiff_path = '/',
    $rdiff_extra_parameters = '',
    $rdiff_keep = '4W',
    $mysql_sshuser = 'root',
    $mysql_sshkey = '.ssh/id_rsa',
    $command_to_execute = '/bin/true',
    # Cron job options
    $cron_hour = '03',
    $cron_minute = '00',
    $cron_weekday = '*'
) {

    # TODO:
    # Virtual resource for the ssh key to be realized on nodes to be backed up
    # command="rdiff-backup --server --restrict-read-only /",from="${backserver}",no-port-forwarding,no-agent-forwarding,no-X11-forwarding,no-pty
    include f3backup::common

    # Virtual resources created by backup clients
    File <<| tag == "f3backup-${backup_server}" |>>

    # Useful to save space across backups of identical OSes
    package { 'hardlinkpy': ensure => installed }

    # Create user backup, who will connect to the clients
    user { 'backup':
        comment    => 'Backup',
        shell      => '/bin/bash',
        home       => $backup_home,
        managehome => true,
    }
    file { "${backup_home}/f3backup":
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        require => User['backup'];
    }
    file { '/var/log/f3backup':
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0700',
        require => User['backup'];
    }

    # Create directory where the ssh key pair will be stored
    file { "${backup_home}/.ssh":
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0700',
        require => User['backup'];
    }
    # Make ssh connections "relaxed" so that things work automatically
    file { "${backup_home}/.ssh/config":
        source  => "puppet:///modules/${module_name}/ssh-config",
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        require => User['backup'];
    }

    # Create the backup user's ssh key pair
    # Note that the pubkey needs to be set in the client
    exec { 'Creating key pair for user backup':
        command => "/usr/bin/ssh-keygen -b 2048 -t rsa -f ${backup_home}/.ssh/id_rsa -N ''",
        user    => 'backup',
        group   => 'backup',
        require => [
            User['backup'],
            File["${backup_home}/.ssh"],
        ],
        creates => "${backup_home}/.ssh/id_rsa",
    }
    
    # The main backup script
    package { 'python-paramiko': ensure => installed }
    file { '/usr/local/bin/f3backup':
        source  => "puppet:///modules/${module_name}/f3backup",
        mode    => '0755',
        require => Package['python-paramiko'],
    }

    # The main configuration and exclude files
    file { '/etc/f3backup.ini':
        content => template('f3backup/f3backup.ini.erb'),
    }
    file { '/etc/f3backup-exclude.txt':
        source  => "puppet:///modules/${module_name}/f3backup-exclude.txt",
    }

    # The cron job to start it all
    cron { 'f3backup':
        command => '/usr/local/bin/f3backup /etc/f3backup.ini',
        user    => 'backup',
        hour    => $cron_hour,
        minute  => $cron_minute,
        weekday => $cron_weekday,
        environment => [ 'MAILTO=root' ],
        require     => [
            User['backup'],
            File['/usr/local/bin/f3backup'],
        ],
    }

}

