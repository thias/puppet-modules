class mysql::serverbase ( $mysql_rootpw ) {

    $archpackages = $::architecture ? {
        'x86_64' => [ "mysql.x86_64" ],
        default  => [ "mysql" ],
    }
    package { $archpackages:
        ensure => installed,
    }
    package { [ "mysql-server", "mytop" ] :
        ensure => installed,
    }

    file {'/root/.my.cnf':
        content => template('mysql/root-my.cnf.erb'),
        require => [ Package[mysql-server] ],
        owner => root, group => 0, mode => 0400;
    }

    mysql_database { "test":
        require => Service["mysqld"],
        ensure => absent,
    }
    mysql_user{ "@localhost":
        ensure => absent,
        require => Service["mysqld"]
    }
    mysql_user{ "@${::fqdn}":
        ensure => absent,
        require => Service["mysqld"]
    }

    ## Create BigBrother user for monitoring with limited privileges
    #mysql_user{ "bb@x0r.exo.aedgency.lan":
    #    ensure => present,
    #    password_hash => mysql_password("dipDuAdNis"),
    #}
    #mysql_grant { "bb@x0r.exo.aedgency.lan":
    #    privileges => []
    #}

    exec { 'set_mysql_rootpw':
        command => "mysql -uroot -e \"UPDATE mysql.user SET Password = PASSWORD('${mysql_rootpw}') WHERE CONCAT(user, '@', host) like 'root@%'; flush privileges\"",
        onlyif  => "test \\! -f /root/.my.cnf",
        require => Service["mysqld"],
        before  => File["/root/.my.cnf"],
        path    => [ "/usr/bin" ],
    }

    service { "mysqld":
       ensure    => running,
       enable    => true,
       hasstatus => true,
       require   => Package["mysql-server"],
    }

    # Collect all databases and users
    Mysql_database <<| tag == "mysql_${::fqdn}" |>>
    Mysql_user <<| tag == "mysql_${::fqdn}"  |>>
    Mysql_grant <<| tag == "mysql_${::fqdn}" |>>

}

