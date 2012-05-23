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
    file { "${nagios::params::plugin_dir}/check_cpu":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_cpu'),
        ensure  => $ensure,
    }
    nagios::client::nrpe { 'check_cpu':
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

/*
    @@nagios_service { "check_cpu_${title}":
        host_name           => $title,
        check_command       => 'check_nrpe_cpu',
        service_description => 'cpu',
        servicegroups       => $servicegroups,
        # Support an arrays of tags for multiple nagios servers
        tag                 => regsubst($nagios::var::server,'^(.+)$','nagios-\1'),
        check_period        => $::nagios_check_cpu_check_period,
        notification_period => $::nagios_check_cpu_notification_period,
        max_check_attempts  => $::nagios_check_cpu_max_check_attempts,
        ensure              => $ensure,
    }
*/

}

