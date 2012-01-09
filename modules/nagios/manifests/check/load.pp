define nagios::check::load () {

    # Generic overrides
    if $::nagios_check_load_check_period != '' {
        Nagios_service { check_period => $::nagios_check_load_check_period }
    }
    if $::nagios_check_load_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_load_notification_period }
    }

    # Service specific overrides
    if ( $::nagios_check_load_warning  != '' ) and
       ( $::nagios_check_load_critical != '' ) {
        $warning  = $::nagios_check_load_warning
        $critical = $::nagios_check_load_critical
    } else {
        # If both thresholds aren't specified, we choose defaults based on the
        # number of processors.
        if ( $::processorcount > 8 ) {
            $warning  = '25,20,20'
            $critical = '40,35,35'
        } elsif ( $::processorcount > 4 ) and ( $::processorcount <= 8 ) {
            $warning  = '20,15,15'
            $critical = '35,30,30'
        } else {
            $warning  = '15,10,10'
            $critical = '30,25,25'
        }
    }
            
    nagios::package { 'nagios-plugins-load': }

    nagios::client::nrpe { 'check_load':
        args => "-w ${warning} -c ${critical}",
    }

    @@nagios_service { "check_load_${title}":
        check_command       => 'check_nrpe_load',
        service_description => 'load',
        #servicegroups       => 'load',
        tag                 => "nagios-${nagios::var::server}",
    }

}

