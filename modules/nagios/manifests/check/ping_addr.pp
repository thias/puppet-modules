define nagios::check::ping_addr () {

    # Generic overrides
    if $::nagios_check_ping_addr_check_period != '' {
        Nagios_service { check_period => $::nagios_check_ping_addr_check_period }
    }
    if $::nagios_check_ping_addr_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_ping_addr_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_ping_addr_address != '' {
        $address = $::nagios_check_ping_addr_address
    } else {
        $address = $nagios::client::host_address
    }
    if $::nagios_check_ping_addr_warning != '' {
        $warning = $::nagios_check_ping_addr_warning
    } else {
        $warning = '2000.0,50%'
    }
    if $::nagios_check_ping_addr_critical != '' {
        $critical = $::nagios_check_ping_addr_critical
    } else {
        $critical = '5000.0,100%'
    }

    nagios::service { "check_ping_addr_${title}":
        check_command       => "check_ping_addr!${address}!${warning}!${critical}",
        service_description => 'ping_addr',
        #servicegroups       => 'ping_addr',
    }

}

