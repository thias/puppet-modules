define nagios::check::swap ( $args = '' ) {

    # Generic overrides
    if $::nagios_check_swap_check_period != '' {
        Nagios_service { check_period => $::nagios_check_swap_check_period }
    }
    if $::nagios_check_swap_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_swap_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_swap_warning != '' {
        $warning = $::nagios_check_swap_warning
    } else {
        $warning = '5%'
    }
    if $::nagios_check_swap_critical != '' {
        $critical = $::nagios_check_swap_critical
    } else {
        $critical = '2%'
    }

    nagios::package { 'nagios-plugins-swap': }

    nagios::client::nrpe { 'check_swap':
        args => "-w ${warning} -c ${critical} ${args}",
    }

    @@nagios_service { "check_swap_${title}":
        check_command       => 'check_nrpe_swap',
        service_description => 'swap',
        #servicegroups       => 'swap',
        tag                 => "nagios-${nagios::var::server}",
    }

}

