class php::fpm::daemon (
    $ensure = 'present',
    $log_level = 'notice',
    $emergency_restart_threshold = '0',
    $emergency_restart_interval = '0',
    $process_control_timeout = '0',
    $log_owner = 'root',
    $log_group = false,
    $pidfile = $php::params::fpm_pid,
    $error_log = $php::params::fpm_error_log
) inherits php::params {

    # Hack-ish to default to user for group too
    $log_group_final = $log_group ? {
        false   => $log_owner,
        default => $log_group,
    }

    if ( $ensure == 'absent' ) {

        package { 'php-fpm': ensure => absent }

    } else {

        realize Package[$php::params::package_fpm]

        service { $php::params::fpm_service:
            ensure    => running,
            enable    => true,
            restart   => "/etc/init.d/${php::params::fpm_service} reload",
            hasstatus => true,
            require   => Package[$php::params::package_fpm],
        }

        # When running FastCGI, we don't always use the same user
        file { '/var/log/php-fpm':
            ensure  => directory,
            owner   => $log_owner,
            group   => $log_group_final,
            require => Package[$php::params::package_fpm],
        }

        file { $php::params::fpm_conf:
            notify  => Service[$php::params::fpm_service],
            content => template('php/fpm/php-fpm.conf.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }

        # For distributions where it doesn't exist by default
        file { $php::params::fpm_confd:
            ensure => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        }

    }

}

