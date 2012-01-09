define nagios::check::ping () {

    # Generic overrides
    if $::nagios_check_ping_check_period != '' {
        Nagios_service { check_period => $::nagios_check_ping_check_period }
    }
    if $::nagios_check_ping_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_ping_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_ping_warning != '' {
        $warning = $::nagios_check_ping_warning
    } else {
        $warning = '2000.0,50%'
    }
    if $::nagios_check_ping_critical != '' {
        $critical = $::nagios_check_ping_critical
    } else {
        $critical = '5000.0,100%'
    }

    @@nagios_service { "check_ping_${title}":
        check_command       => "check_ping!${warning}!${critical}",
        service_description => 'ping',
        #servicegroups       => 'ping',
        tag                 => "nagios-${nagios::var::server}",
    }

}

