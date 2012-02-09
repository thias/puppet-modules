define nagios::check::cpu ( $args = '' ) {

    # Generic overrides
    if $::nagios_check_cpu_check_period != '' {
        Nagios_service { check_period => $::nagios_check_cpu_check_period }
    }
    if $::nagios_check_cpu_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_cpu_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_cpu_warning != '' {
        $warning = $::nagios_check_cpu_warning
    } else {
        $warning = '10'
    }
    if $::nagios_check_cpu_critical != '' {
        $critical = $::nagios_check_cpu_critical
    } else {
        $critical = '5'
    }

    file { "${nagios::client::plugin_dir}/check_cpu":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_cpu'),
        ensure  => $ensure,
    }

    nagios::client::nrpe { 'check_cpu':
        args => "-w ${warning} -c ${critical} ${args}",
    }

    @@nagios_service { "check_cpu_${title}":
        check_command       => 'check_nrpe_cpu',
        service_description => 'cpu',
        #servicegroups       => 'cpu',
        tag                 => "nagios-${nagios::var::server}",
    }

}

