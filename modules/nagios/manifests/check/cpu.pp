define nagios::check::cpu (
    $args                = $::nagios_check_cpu_args,
    $servicegroups       = $::nagios_check_cpu_servicegroups,
    $check_period        = $::nagios_check_cpu_check_period,
    $max_check_attempts  = $::nagios_check_cpu_max_check_attempts,
    $notification_period = $::nagios_check_cpu_notification_period,
    $use                 = $::nagios_check_cpu_use,
    $ensure              = $::nagios_check_cpu_ensure
) {

    # Service specific script
    file { "${nagios::client::plugin_dir}/check_cpu":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_cpu'),
        ensure  => $ensure,
    }
    nagios::client::nrpe_file { 'check_cpu':
        args   => $args ? { '' => '-w 10 -c 5', default => $args },
        ensure => $ensure,
    }

    nagios::service { "check_cpu_${title}":
        check_command       => 'check_nrpe_cpu',
        service_description => 'cpu',
        servicegroups       => $servicegroups,
        check_period        => $check_period,
        max_check_attempts  => $max_check_attempts,
        notification_period => $notification_period,
        use                 => $use,
        ensure              => $ensure,
    }

}

