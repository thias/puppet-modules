define nagios::check::membase (
    $ensure = undef,
    $args = '',
    $membase_data_file_name = '/tmp/membase_data_file_name',
    $membase_mbstats = '/opt/membase/bin/mbstats',
    $membase_host = '127.0.0.1',
    $membase_port = '11211'
) {

    # Generic overrides
    if $::nagios_check_membase_check_period != '' {
        Nagios_service { check_period => $::nagios_check_membase_check_period }
    }
    if $::nagios_check_membase_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_membase_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_membase_args != '' {
        $fullargs = $::nagios_check_membase_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_membase":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_membase.erb'),
        ensure  => $ensure,
    }

    nagios::client::nrpe_file { 'check_membase':
        args    => $fullargs,
        ensure  => $ensure,
    }

    nagios::service { "check_membase_${title}":
        check_command       => 'check_nrpe_membase',
        service_description => 'membase',
        #servicegroups       => 'membase',
        ensure              => $ensure,
    }

}

