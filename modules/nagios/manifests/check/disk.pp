define nagios::check::disk ( $args = '' ) {

    # Generic overrides
    if $::nagios_check_disk_check_period != '' {
        Nagios_service { check_period => $::nagios_check_disk_check_period }
    }
    if $::nagios_check_disk_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_disk_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_disk_warning != '' {
        $warning = $::nagios_check_disk_warning
    } else {
        $warning = '5%'
    }
    if $::nagios_check_disk_critical != '' {
        $critical = $::nagios_check_disk_critical
    } else {
        $critical = '2%'
    }

    nagios::package { 'nagios-plugins-disk': }

    nagios::client::nrpe { 'check_disk':
        # -l : Don't check network mounts, local (and checked) elsewhere
        # binfmt_misc : Denied by default, not useful to monitor
        # rpc_pipefs  : Denied by default, not useful to monitor
        args => "-l -X binfmt_misc -X rpc_pipefs -w ${warning} -c ${critical} ${args}",
    }

    @@nagios_service { "check_disk_${title}":
        check_command       => 'check_nrpe_disk',
        service_description => 'disk',
        #servicegroups       => 'disk',
        tag                 => "nagios-${nagios::var::server}",
    }

}

