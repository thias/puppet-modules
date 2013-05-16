define nagios::check::dir_status (
    $args,
    $servicegroups       = $::nagios_check_dir_servicegroups,
    $check_period        = $::nagios_check_dir_check_period,
    $max_check_attempts  = $::nagios_check_dir_max_check_attempts,
    $notification_period = $::nagios_check_dir_notification_period,
    $use                 = $::nagios_check_dir_use,
    $ensure              = $::nagios_check_dir_ensure
) {

    include nagios::plugin::dir_status

    nagios::client::nrpe_file { "check_dir_status_${title}":
        args   => $args,
        plugin => 'check_dir_status',
        ensure => $ensure,
    }

    nagios::service { "check_dir_status_${title}_${::nagios::client::host_name}":
        check_command       => "check_nrpe_dir_status_${title}",
        service_description => "dir_status_${title}",
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        max_check_attempts  => $max_check_attempts,
        notification_period => $notification_period,
        use                 => $use,
        ensure              => $ensure,
    }

}

