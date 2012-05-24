define nagios::check::nginx (
    $ensure = undef,
    $args = ''
) {

    # Generic overrides
    if $::nagios_check_nginx_check_period != '' {
        Nagios_service { check_period => $::nagios_check_nginx_check_period }
    }
    if $::nagios_check_nginx_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_nginx_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_nginx_args != '' {
        $fullargs = $::nagios_check_nginx_args
    } else {
        $fullargs = $args
    }

    # Needs "plugin_nginx => true" on nagios::server to get the check script

    nagios::service { "check_nginx_${title}":
        check_command       => "check_nginx!${fullargs}",
        service_description => 'nginx',
        #servicegroups       => 'nginx',
        ensure              => $ensure,
    }

}

