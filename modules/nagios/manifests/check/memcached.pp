define nagios::check::memcached (
    $ensure = undef,
    $args = ''
) {

    # Generic overrides
    if $::nagios_check_memcached_check_period != '' {
        Nagios_service { check_period => $::nagios_check_memcached_check_period }
    }
    if $::nagios_check_memcached_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_memcached_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_memcached_args != '' {
        $fullargs = $::nagios_check_memcached_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_memcached":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_memcached.erb'),
        ensure  => $ensure,
    }

    nagios::client::nrpe_file { 'check_memcached':
        args    => $fullargs,
        ensure  => $ensure,
    }

    nagios::service { "check_memcached_${title}":
        check_command       => 'check_nrpe_memcached',
        service_description => 'memcached',
        #servicegroups       => 'memcached',
        ensure              => $ensure,
    }

}

