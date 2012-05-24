define nagios::check::httpd (
    $args                = $::nagios_check_httpd_args,
    $servicegroups       = $::nagios_check_httpd_servicegroups,
    $check_period        = $::nagios_check_httpd_check_period,
    $max_check_attempts  = $::nagios_check_httpd_max_check_attempts,
    $notification_period = $::nagios_check_httpd_notification_period,
    $use                 = $::nagios_check_httpd_use,
    $ensure              = $::nagios_check_httpd_ensure
) {

    nagios::service { "check_httpd_${title}":
        check_command       => "check_http!${args}",
        service_description => 'httpd',
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        max_check_attempts  => $max_check_attempts,
        notification_period => $notification_period,
        use                 => $use,
        ensure              => $ensure,
    }

}

