# Class: nagios::client
#
# This is the main class to be included on all nodes to be monitored by nagios.
#
class nagios::client (
    $nagios_host_name            = $::nagios_host_name,
    $nagios_server               = $::nagios_server,
    # nrpe.cfg
    $nrpe_log_facility           = 'daemon',
    $nrpe_pid_file               = $nagios::params::nrpe_pid_file,
    $nrpe_server_port            = '5666',
    $nrpe_server_address         = undef,
    $nrpe_user                   = $nagios::params::nrpe_user,
    $nrpe_group                  = $nagios::params::nrpe_group,
    $nrpe_allowed_hosts          = '127.0.0.1',
    $nrpe_dont_blame_nrpe        = '0',
    $nrpe_command_prefix         = undef,
    $nrpe_command_timeout        = '60',
    $nrpe_connection_timeout     = '300',
    # host defaults
    $host_address                = $::nagios_host_address,
    $host_alias                  = $::nagios_host_alias,
    $host_check_period           = $::nagios_host_check_period,
    $host_contact_groups         = $::nagios_host_contact_groups,
    $host_hostgroups             = $::nagios_host_hostgroups,
    $host_notes                  = $::nagios_host_notes,
    $host_notes_url              = $::nagios_host_notes_url,
    $host_notification_period    = $::nagios_host_notification_period,
    $host_use                    = $::nagios_host_use,
    # service defaults (hint: use host_* or override only service_use for efficiency)
    $service_check_period        = $::nagios_service_check_period,
    $service_notification_period = $::nagios_service_notification_period,
    $service_max_check_attempts  = $::nagios_service_max_check_attempts,
    $service_use                 = 'generic-service',
    # other
    $plugin_dir                  = $nagios::params::plugin_dir,
    $selinux                     = true
) inherits nagios::params {

    # Set the variables to be used, including scoped from elsewhere, based on the optional
    # fact or parameter from here
    $host_name = $nagios_host_name ? {
        ''      => $::fqdn,
        default => $nagios_host_name,
    }
    $server = $nagios_server ? {
        ''      => 'default',
        default => $nagios_server,
    }

    # Base package(s)
    package { $nagios::params::nrpe_package:
        ensure => installed,
        alias  => $nagios::params::nrpe_package_alias,
    }

    # Most plugins use nrpe, so we install it everywhere
    service { $nagios::params::nrpe_service:
        ensure    => running,
        enable    => true,
        hasstatus => true,
        subscribe => File[$nagios::params::nrpe_cfg_file],
    }
    file { $nagios::params::nrpe_cfg_file:
        owner   => 'root',
        group   => $nrpe_group,
        mode    => '0640',
        content => template('nagios/nrpe.cfg.erb'),
        require => Package['nrpe']
    }
    # Included in the package, but we need to enable purging
    file { $nagios::params::nrpe_cfg_dir:
        owner   => 'root',
        group   => $nrpe_group,
        mode    => '0750',
        purge   => true,
        recurse => true,
        ensure  => directory,
        require => Package['nrpe'],
    }

    # Where to store configuration for our custom nagios_* facts
    file { '/etc/nagios/facter':
        ensure  => directory,
        purge   => true,
        recurse => true,
        require => Package['nrpe'],
    }

    # The main nagios_host entry
    nagios::host { $host_name:
        server              => $server,
        address             => $host_address,
        host_alias          => $host_alias,
        check_period        => $host_check_period,
        contact_groups      => $host_contact_groups,
        hostgroups          => $host_hostgroups,
        notes               => $host_notes,
        notes_url           => $host_notes_url,
        notification_period => $host_notification_period,
        use                 => $host_use,
    }

    # TODO: Remove once all check/*.pp files are updated
    Nagios_service {
        use => 'generic-service,nagiosgraph-service',
    }

    # Enable all default checks by... default
    include nagios::defaultchecks
    # Default checks, enabled on all hosts
    nagios::check::cpu { $host_name: }
    nagios::check::disk { $host_name: }
    if $::nagios_httpd == 'true' {
        nagios::check::httpd { $host_name: }
    } else {
        nagios::check::httpd { $host_name: ensure => absent }
    }
    nagios::check::load { $host_name: }
    nagios::check::ping { $host_name: }

    # With selinux, many nrpe plugins require additional rules to work
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'nrpe':
            source => 'puppet:///modules/nagios/messages.nrpe',
        }
    }

}

