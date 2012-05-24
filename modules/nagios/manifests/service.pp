# Define: nagios::service
#
# Wrap around the original nagios_service
# * To be able to export with the correct tag automatically
# * To be able to use defaults overridden or from facts
#
define nagios::service (
    $server              = $nagios::client::server,
    $host_name           = $nagios::client::host_name,
    $check_command,
    $service_description = $name,
    $servicegroups       = undef,
    $check_period        = $nagios::client::service_check_period,
    $max_check_attempts  = $nagios::client::service_max_check_attempts,
    $notification_period = $nagios::client::service_notification_period,
    $use                 = $nagios::client::service_use,
    $ensure              = undef
) {

    # Work around being passed undefined variables resulting in ''
    $final_check_period = $check_period ? {
        ''      => $nagios::client::service_check_period,
        default => $check_period,
    }
    $final_max_check_attempts = $max_check_attempts ? {
        ''      => $nagios::client::service_max_check_attempts,
        default => $max_check_attempts,
    }
    $final_notification_period = $notification_period ? {
        ''      => $nagios::client::service_notification_period,
        default => $notification_period,
    }
    $final_use = $use ? {
        ''      => $nagios::client::service_use,
        default => $use,
    }

    @@nagios_service { $title:
        host_name           => $host_name,
        check_command       => $check_command,
        service_description => $service_description,
        servicegroups       => $servicegroups,
        check_period        => $final_check_period,
        max_check_attempts  => $final_max_check_attempts,
        notification_period => $final_notification_period,
        use                 => $final_use,
        # Support an arrays of tags for multiple nagios servers
        tag                 => regsubst($server,'^(.+)$','nagios-\1'),
        ensure              => $ensure,
    }

}

