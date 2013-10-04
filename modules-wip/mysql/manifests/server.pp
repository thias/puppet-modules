# This module installs and configures MySQL
#
# To install a new MySQL server, just define mysql::server::configure in the
# host definition.
#
# It can accept many different parameters. For example:
# class { 'mysql::server':
#     mysql_rootpw       => 'foobar',
#     skipnetworking     => true,
#     skipinnodb         => true,
#     backup_keepdays    => 2,
# }
#
# To create a new database:
# mysql_database { "database1": ensure => present }
#
# To create a new user (without any privilege):
# mysql_user { "user@%":
#     ensure => present,
#     password_hash => mysql_password("newpassword"),
# }
#
# To assign all privileges to an user (including GRANT and SUPER):
# mysql_grant { "user@%":
#     privileges => "all",
# }
#
# To assign specific db privileges to an user:
# mysql_grant { "user@%/database1":
#     privileges => [ "select_priv", 'insert_priv', 'update_priv', 'delete_priv' ],
# }
#
#

class mysql::server (
    $root_password,
    $skipnetworking = false,
    $query_cache_size = 4M,
    $query_cache_limit = 2M,
    $key_buffer = 256M,
    $key_buffer_size = 64M,
    $table_cache = 256,
    $thread_cache = 0,
    $thread_cache_size = 20,
    $thread_concurrency = false, #defaults to number of CPUs * 2
    $join_buffer_size = 8M,
    $sort_buffer_size = 8M,
    $read_buffer_size = 8M,
    $read_rnd_buffer_size = 4M,
    $tmp_table_size = 4M,
    $max_heap_table_size = 4M,
    $max_connections = 200,
    $open_files_limit = false,
    $max_allowed_packet = false,
    $innodb_file_per_table = false,
    $skipinnodb = false,
    $innodb_buffer_pool_size = 256M,
    $innodb_lock_wait_timeout = 30M,
    $innodb_thread_concurrency = 8,
    $innodb_log_file_size = 5242880,
    $restart_on_change = true,
    $replication_master = false,
    $replication_slave = false,
    $binlogs_to_keep = 5,
    $binlog_format = false,
    $relay_log_space_limit = 0,
    $backup = true,
    $backup_dir = '/var/lib/mysql-backup',
    $backup_hour = '6',
    $backup_minute = '30',
    $backup_keepdays = '5',
    $processorcount = $::processorcount,
    $mycnf_mysql = undef,
    $mycnf_mysqld = [],
    $mycnf_content = undef,
    $mycnf_source = undef

) {

    if $mycnf_content or $mycnf_source {
        file { '/etc/my.cnf':
            content => $mycnf_content,
            source  => $mycnf_source,
        }
    } elsif $mycnf_mysqld != [] {
        file { '/etc/my.cnf':
            content => template('mysql/my.cnf.erb'),
        }
    } else {
        file { '/etc/my.cnf':
            content => template('mysql/my.cnf-old.erb'),
        }
    }
    if $restart_on_change {
        File['/etc/my.cnf'] ~> Service['mysqld']
    }

    # Optional backup
    class { 'mysql::backup':
        backup_dir      => $backup_dir,
        backup_hour     => $backup_hour,
        backup_minute   => $backup_minute,
        backup_keepdays => $backup_keepdays,
        ensure    => $backup ? {
            true  => 'present',
            false => 'absent',
        },
    }

    $archpackage = $::architecture ? {
        'x86_64' => [ 'mysql.x86_64' ],
        default  => [ 'mysql' ],
    }
    package { [ $archpackage, 'mysql-server' ]: ensure => installed, }

    file {'/root/.my.cnf':
        content => template('mysql/root-my.cnf.erb'),
        require => Package['mysql-server'],
        owner   => 'root',
        group   => 'root',
        mode    => '0400';
    }

    # Remove default databases and users
    Mysql_database { require => Service['mysqld'] }
    Mysql_user     { require => Service['mysqld'] }
    mysql_database { 'test':       ensure  => absent }
    mysql_user     { '@localhost': ensure  => absent }
    mysql_user     { "@${::fqdn}": ensure  => absent }

    exec { 'set_mysql_root_password':
        command => "mysql -uroot -e \"UPDATE mysql.user SET Password = PASSWORD('${root_password}') WHERE User = 'root'; flush privileges\"",
        unless  => "egrep -q '^password=${root_password}\$' /root/.my.cnf",
        require => Service['mysqld'],
        before  => File['/root/.my.cnf'],
        path    => [ '/bin', '/usr/bin' ],
    }

    service { 'mysqld':
       ensure    => running,
       enable    => true,
       hasstatus => true,
       require   => Package['mysql-server'],
    }

    # Collect all databases and users
    Mysql_database <<| tag == "mysql_${::fqdn}" |>>
    Mysql_user <<| tag == "mysql_${::fqdn}"  |>>
}
