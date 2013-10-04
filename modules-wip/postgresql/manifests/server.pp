# PostgreSQL Server class.
#
class postgresql::server (
    $rpmbasename = 'postgresql',
    # Original pg_hba lines
    $pg_hba_lines = [
        'local all all              ident',
        'host  all all 127.0.0.1/32 ident',
        'host  all all ::1/128      ident',
    ]
) {
    package { "${rpmbasename}-server": ensure => installed }
    # The PostgreSQL server requires this initially
    exec { '/sbin/service postgresql initdb':
        require => Package['postgresql-server'],
        creates => '/var/lib/pgsql/data/PG_VERSION',
    }
    service { 'postgresql':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        restart   => '/sbin/service postgresql reload',
        require   => Exec['/sbin/service postgresql initdb'],
    }
    file { '/var/lib/pgsql/data/pg_hba.conf':
        content => template('postgresql/pg_hba.conf.erb'),
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0600',
        require => Package['postgresql-server'],
        notify  => Service['postgresql'],
    }
}

