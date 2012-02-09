define nagios::check::megaraid_sas (
    $ensure = undef,
    $args = '',
    $pkg = true,
    $megaclibin = '/usr/sbin/MegaCli'
) {

    # Generic overrides
    if $::nagios_check_megaraid_sas_check_period != '' {
        Nagios_service { check_period => $::nagios_check_megaraid_sas_check_period }
    }
    if $::nagios_check_megaraid_sas_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_megaraid_sas_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_megaraid_sas_args != '' {
        $fullargs = $::nagios_check_megaraid_sas_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_megaraid_sas":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        # We customize the MegaCli path, plugin path
        content => template('nagios/plugins/check_megaraid_sas.erb'),
        ensure  => $ensure,
    }
    # The check executes MegaCli using sudo
    file { '/etc/sudoers.d/nagios_check_megaraid_sas':
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        # We customize the MegaCli path and the user
        content => template('nagios/plugins/check_megaraid_sas-sudoers.erb'),
        ensure  => $ensure,
    }
    # Optional package containing MegaCli
    if $pkg {
        $pkgname = $operatingsystem ? {
            'Gentoo' => 'sys-block/megacli',
             default => 'megacli',
        }
        package { $pkgname:
            ensure => $ensure ? {
                'absent' => 'absent',
                 default => 'installed',
            }
        }
    }

    nagios::client::nrpe { 'check_megaraid_sas':
        args   => $fullargs,
        ensure => $ensure,
    }

    @@nagios_service { "check_megaraid_sas_${title}":
        check_command       => 'check_nrpe_megaraid_sas',
        service_description => 'megaraid_sas',
        #servicegroups       => 'megaraid_sas',
        tag                 => "nagios-${nagios::var::server}",
        ensure              => $ensure,
    }

}

