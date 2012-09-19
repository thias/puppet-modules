class mysql::backup (
    $backup_dir,
    $backup_hour,
    $backup_minute,
    $backup_keepdays,
    $ensure = 'present'
) {

    file { [
        "${backup_dir}",
        "${backup_dir}/day",
        "${backup_dir}/month",
    ]:
        mode   => '0700',
        ensure => $ensure ? {
            'absent' => 'absent',
             default => 'directory',
        },
    }
    cron { 'mysql-full':
        command => '/usr/local/bin/mysql-full >/dev/null',
        user    => 'root',
        hour    => $backup_hour,
        minute  => $backup_minute,
        ensure  => $ensure,
    }
    file { '/usr/local/bin/mysql-full':
        content => template('mysql/mysql-full.erb'),
        mode    => '0755',
        ensure  => $ensure,
    }
}

