define nagios::check::moxi (
    $ensure = undef,
    $args = ''
) {

    # Generic overrides
    if $::nagios_check_moxi_check_period != '' {
        Nagios_service { check_period => $::nagios_check_moxi_check_period }
    }
    if $::nagios_check_moxi_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_moxi_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_moxi_args != '' {
        $fullargs = $::nagios_check_moxi_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_moxi":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_moxi'),
        ensure  => $ensure,
    }

    nagios::client::nrpe_file { 'check_moxi':
        args    => $fullargs,
        ensure  => $ensure,
    }

    nagios::service { "check_moxi_${title}":
        check_command       => 'check_nrpe_moxi',
        service_description => 'moxi',
        #servicegroups       => 'moxi',
        ensure              => $ensure,
    }

}

