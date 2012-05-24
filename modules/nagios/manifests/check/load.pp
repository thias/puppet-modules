define nagios::check::load (
    $args                = $::nagios_check_load_args,
    $servicegroups       = $::nagios_check_load_servicegroups,
    $check_period        = $::nagios_check_load_check_period,
    $max_check_attempts  = $::nagios_check_load_max_check_attempts,
    $notification_period = $::nagios_check_load_notification_period,
    $use                 = $::nagios_check_load_use,
    $ensure              = $::nagios_check_load_ensure
) {

    if $ensure != 'absent' {
        Package <| tag == 'nagios-plugins-load' |>
    }

    # We choose defaults based on the number of CPU cores.
    if $args == '' {
        if ( $::processorcount > 8 ) {
            $final_args = '-w 25,20,20 -c 40,35,35'
        } elsif ( $::processorcount > 4 ) and ( $::processorcount <= 8 ) {
            $final_args = '-w 20,15,15 -c 35,30,30'
        } else {
            $final_args = '-w 15,10,10 -c 30,25,25'
        }
    } else {
        $final_args = $args
    }
    nagios::client::nrpe_file { 'check_load':
        args   => $final_args,
        ensure => $ensure,
    }

    nagios::service { "check_load_${title}":
        check_command       => 'check_nrpe_load',
        service_description => 'load',
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        max_check_attempts  => $max_check_attempts,
        notification_period => $notification_period,
        use                 => $use,
        ensure              => $ensure,
    }

}

