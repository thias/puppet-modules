define nagios::check::httpd (
    $ensure = undef,
    $args = ''
) {

    # Generic overrides
    if $::nagios_check_httpd_check_period != '' {
        Nagios_service { check_period => $::nagios_check_httpd_check_period }
    }
    if $::nagios_check_httpd_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_httpd_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_httpd_args != '' {
        $fullargs = $::nagios_check_httpd_args
    } else {
        $fullargs = $args
    }

    @@nagios_service { "check_httpd_${title}":
        check_command       => "check_http!${fullargs}",
        service_description => 'httpd',
        #servicegroups       => 'httpd',
        tag                 => "nagios-${nagios::var::server}",
        ensure              => $ensure,
    }

}

