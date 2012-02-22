# Testing, 1... 2... 3...
#
# Wrap around the original nagios_service
# * To be able to export with the default tag
# * To be able to use defaults set by the module
#
define nagios::service (
    $host_name           = $nagios::var::host_name,
    $check_command,
    $service_description = $name,
    $servicegroups       = undef,
    $check_period        = $nagios::var::check_period,
    $notification_period = $nagios::var::notification_period,
    $use                 = $nagios::client::nagios_service_use
) {

    @@nagios_service { $title:
        host_name           => $host_name,
        check_command       => $check_command,
        service_description => $service_description,
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        notification_period => $notification_period,
        tag                 => "nagios-${nagios::var::server}",
        use                 => $use,
    }

}

