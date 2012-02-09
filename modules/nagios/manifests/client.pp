class nagios::client (
    # nrpe.cfg
    $nrpe_log_facility = 'daemon',
    $nrpe_pid_file = '/var/run/nrpe.pid',
    $nrpe_server_port = '5666',
    $nrpe_server_address = undef,
    $nrpe_user = 'nrpe',
    $nrpe_group = 'nrpe',
    $nrpe_allowed_hosts = '127.0.0.1',
    $nrpe_dont_blame_nrpe = '0',
    $nrpe_command_prefix = undef,
    $nrpe_command_timeout = '60',
    $nrpe_connection_timeout = '300',
    # other
    $nagios_service_use = 'generic-service',
    $plugin_dir = '/usr/libexec/nagios/plugins',
    $perl = true,
    $selinux = true
) {

    # Get all of the variables
    include nagios::var

#    $nagiosgraph    = false,
#    # set as variable so we can have various nagios servers in the future and allow them depending on the platform
#    $nagios_server  = [ '192.168.49.13', '91.121.108.16' ],
#    $nagios_notification_period = '24x7'

    # Base packages
    if ( $operatingsystem == 'RedHat' ) {
        package { [ 'nrpe', 'nagios-plugins' ]: ensure => installed }
    } elsif ( $operatingsystem == 'Gentoo' ) {
        package { 'net-analyzer/nagios-nrpe':
            alias  => 'nrpe',
            ensure => installed,
        }
    }

    # Most plugins use nrpe, so we install it everywhere
    service { 'nrpe':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        subscribe => File['/etc/nagios/nrpe.cfg'],
    }
    file { '/etc/nagios/nrpe.cfg':
        owner   => 'root',
        group   => $nrpe_group,
        mode    => '0640',
        content => template('nagios/nrpe.cfg.erb'),
        require => Package['nrpe']
    }
    # Included in the package, but we need to enable purging
    file { '/etc/nagios/nrpe.d':
        owner   => 'root',
        group   => $nrpe_group,
        mode    => '0750',
        purge   => true,
        recurse => true,
        ensure  => directory,
        require => Package['nrpe'],
    }

    # Where to store configuration for our custom nagios_* facts
    file { '/etc/nagios/facter':
        ensure  => directory,
        purge   => true,
        recurse => true,
        require => Package['nrpe'],
    }

    # Optional plugin packages, to be realized where needed
    # The main magic is in nagios::package
    if $operatingsystem == 'RedHat' {
        @package { [
            'nagios-plugins-disk',
            'nagios-plugins-file_age',
            'nagios-plugins-ide_smart',
            'nagios-plugins-ifstatus',
            'nagios-plugins-linux_raid',
            'nagios-plugins-load',
            'nagios-plugins-log',
            'nagios-plugins-mailq',
            'nagios-plugins-mysql',
            'nagios-plugins-mysql_health',
            'nagios-plugins-ntp',
            'nagios-plugins-oracle_health',
            'nagios-plugins-perl',
            'nagios-plugins-pgsql',
            'nagios-plugins-procs',
            'nagios-plugins-sensors',
            'nagios-plugins-swap',
            'nagios-plugins-users',
        ]:
            ensure => installed,
        }
    } elsif $operatingsystem == 'Gentoo' {
        # No package splitting in Gentoo
        @package { 'net-analyzer/nagios-plugins':
            ensure => installed,
        }
    }

    # The main nagios_host entry
    @@nagios_host { $nagios::var::host_name:
        alias               => $nagios::var::host_alias,
        address             => $nagios::var::host_address,
        use                 => $nagios::var::host_use,
        #hostgroups =>
        #icon_image =>
        #statusmap_image =>
        check_period        => $nagios::var::check_period,
        notification_period => $nagios::var::notification_period,
        notes               => $nagios::var::host_notes,
        notes_url           => $nagios::var::host_notes_url,
        tag                 => "nagios-${nagios::var::server}",
    }

    # Set the defaults for all service checks ("tag" doesn't work here)
    Nagios_service {
        host_name => $nagios::var::host_name,
        use       => $nagios_service_use,
    }
    include nagios::checks

    # The perl bindings are required by multiple packages
    if $perl {
        nagios::package { 'nagios-plugins-perl': }
    }

    # With selinux, many nrpe plugins require additional rules to work
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'nrpe':
            source => 'puppet:///modules/nagios/messages.nrpe',
        }
    }

/*
    #include nagios::defaultchecks
    class { 'nagios::defaultchecks': nagios_notification_period => $nagios_notification_period;}

    # Other packages, required by some plugins
    @package { [
        'afaapps',
        'lsiutil',
        'megacli',
        'megarc',
        'perl-libwww-perl',
    ]:
        ensure => installed,
    }

    # Script used for many different checks. Just realize it to include it
    @file { "${nagios::client::plugin_dir}/check_logfile":
        source  => 'puppet:///modules/nagios/plugins/check_logfile',
        mode    => '0755',
        require => Package['nagios-plugins'],
    }

    include sudoers
*/
}

