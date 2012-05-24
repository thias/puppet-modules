define nagios::check::disk (
    # We want to be able to manipulate the arguments in 3 parts :
    # default_args : useful default set for all nodes
    # args : the main warning and critical values
    # extra_args : optional additional arguments
    $default_args        = $::nagios_check_disk_default_args,
    $args                = $::nagios_check_disk_args,
    $extra_args          = $::nagios_check_disk_extra_args,
    $servicegroups       = $::nagios_check_disk_servicegroups,
    $check_period        = $::nagios_check_disk_check_period,
    $max_check_attempts  = $::nagios_check_disk_max_check_attempts,
    $notification_period = $::nagios_check_disk_notification_period,
    $use                 = $::nagios_check_disk_use,
    $ensure              = $::nagios_check_disk_ensure
) {

    if $ensure != 'absent' {
        Package <| tag == 'nagios-plugins-disk' |>
    }

    $final_original_args = $original_args ? {
        # -l : Don't check network mounts, local (and checked) elsewhere
        # binfmt_misc : Denied by default, not useful to monitor
        # rpc_pipefs  : Denied by default, not useful to monitor
        ''      => '-l -X binfmt_misc -X rpc_pipefs',
        default => $original_args,
    }
    $final_args = $args ? {
        ''      => ' -w 5% -c 2%',
        default => " ${args}",
    }
    $final_extra_args = $extra_args ? {
        ''      => '',
        default => " ${extra_args}",
    }
    nagios::client::nrpe_file { 'check_disk':
        args   => "${final_original_args}${final_args}${final_extra_args}",
        ensure => $ensure,
    }

    nagios::service { "check_disk_${title}":
        check_command       => 'check_nrpe_disk',
        service_description => 'disk',
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        max_check_attempts  => $max_check_attempts,
        notification_period => $notification_period,
        use                 => $use,
        ensure              => $ensure,
    }

}

