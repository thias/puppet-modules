# This module installs and configures MySQL
#
# To install a new MySQL server, just define mysql::server::configure in the
# host definition.
#
# It can accept many different parameters. For example:
# class { 'mysql::server':
#     mysql_rootpw       => 'foobar',
#     old_passwords      => false,
#     skipnetworking     => false,
#     skipinnodb         => false,
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
# To create a default mydba user for dba admins:
#
# $mysql_mydbapw="mydbapassword"
# include mysql::user::mydba
#

class mysql::server (

    $mysql_rootpw,
    $old_passwords  = false,
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
    $restart_on_update = true,
    $replication_master = false,
    $replication_slave = false,
    $binlogs_to_keep = 5,
    $binlog_format = false,
    $relay_log_space_limit = 0,
    $backup = true,
    $backup_dir = "/var/lib/mysql-backup",
    $backup_keepdays = "5",
    $backup_hour = "6",
    $backup_minute = "30",
    $processorcount = $::processorcount

) {

    class { 'mysql::serverbase': mysql_rootpw => $mysql_rootpw }

    $my_old_passwords = $old_passwords ? {
        true    => "1",
        default => "0",
    }

    # yeah... yeah... I know it's ugly. This is how puppet works
    if $restart_on_update {
        file { "/etc/my.cnf":
            content => template("mysql/my.cnf.erb"),
            notify  => Service["mysqld"],
        }
    } else {
        file { "/etc/my.cnf":
            content => template("mysql/my.cnf.erb"),
        }
    }

    if $replication_slave {
        file { "/var/lib/mysql/.mysql_is_slave":
            ensure  => present,
            content => "true",
        }
    } else {
        file { "/var/lib/mysql/.mysql_is_slave":
            ensure => absent,
        }
    }

    if $replication_master {
        file { "/var/lib/mysql/.mysql_is_master":
            ensure  => present,
            content => "true",
        }
        mysql_user { "replication@%":
            ensure        => present,
            password_hash => mysql_password("HidPyHogew"),
        }
        mysql_grant { "replication@%":
            privileges => "repl_slave_priv",
        }
        package { "MySQL-python" :
            ensure => installed,
        }
        file { "/usr/local/bin/purgeBinaryLogs.py":
            source => "puppet:///modules/mysql/purgeBinaryLogs.py",
            mode   => 0755,
        }
        cron { "purgeBinaryLogs":
            command => "/usr/local/bin/purgeBinaryLogs.py -H localhost -l $binlogs_to_keep",
            user    => "root",
            minute  => "0",
        }
    } else {
        file { "/var/lib/mysql/.mysql_is_master":
            ensure => absent,
        }
        file { "/usr/local/bin/purgeBinaryLogs.py":
            ensure => absent,
        }
        cron { "purgeBinaryLogs":
            ensure => absent,
        }
    }

    # Optional backup
    if $backup {
        file { [
             "${backup_dir}",
             "${backup_dir}/day",
             "${backup_dir}/month",
        ]:
            ensure => "directory",
            mode   => 0700,
        }
        cron { "mysql-full":
            command => "/usr/local/bin/mysql-full >/dev/null",
            user    => "root",
            hour    => $backup_hour,
            minute  => $backup_minute,
        }
        file { "/usr/local/bin/mysql-full":
            content => template("mysql/mysql-full.erb"),
            mode    => 0755,
        }
    } else {
        cron { "mysql-full": ensure => absent }
        file { "/usr/local/bin/mysql-full": ensure => absent }
    }
    # Obsolete files, to be removed
    file { "/etc/cron.d/mysql-full": ensure => absent }
    file { "/usr/local/bin/mysql-full.sh": ensure => absent }
}
