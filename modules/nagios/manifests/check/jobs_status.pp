define nagios::check::jobs_status (
    $ensure = undef,
    $args = ''
) {

    # Generic overrides
    if $::nagios_check_jobs_status_check_period != '' {
        Nagios_service { check_period => $::nagios_check_jobs_status_check_period }
    }
    if $::nagios_check_jobs_status_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_jobs_status_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_jobs_status_args != '' {
        $fullargs = $::nagios_check_jobs_status_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_jobs_status":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_jobs_status'),
        ensure  => $ensure,
    }

    nagios::client::nrpe { 'check_jobs_status':
        args   => $fullargs,
        ensure => $ensure,
    }

    @@nagios_service { "check_jobs_status_${title}":
        check_command       => 'check_nrpe_jobs_status',
        service_description => 'jobs_status',
        #servicegroups       => 'jobs_status',
        tag                 => "nagios-${nagios::var::server}",
        ensure              => $ensure,
    }

}

