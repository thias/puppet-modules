class nagios::client (
    # nrpe.cfg
    $nrpe_log_facility       = 'daemon',
    $nrpe_pid_file           = $nagios::params::nrpe_pid_file,
    $nrpe_server_port        = '5666',
    $nrpe_server_address     = undef,
    $nrpe_user               = $nagios::params::nrpe_user,
    $nrpe_group              = $nagios::params::nrpe_group,
    $nrpe_allowed_hosts      = '127.0.0.1',
    $nrpe_dont_blame_nrpe    = '0',
    $nrpe_command_prefix     = undef,
    $nrpe_command_timeout    = '60',
    $nrpe_connection_timeout = '300',
    # service defaults
    $service_check_period        = undef,
    $service_notification_period = undef,
    $service_max_check_attempts  = undef,
    $service_use                 = 'generic-service',
    # other
    $perl                    = true,
    $selinux                 = true
) inherits nagios::params {

    # Get all of the possibly-fact-overriden variables or their default values
    include nagios::var

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
    @@nagios_host { $nagios::var::host_name:
        alias               => $nagios::var::host_alias,
        address             => $nagios::var::host_address,
        use                 => $nagios::var::host_use,
        hostgroups          => $nagios::var::host_hostgroups,
        contact_groups      => $nagios::var::host_contact_groups,
        #icon_image =>
        #statusmap_image =>
        check_period        => $nagios::var::host_check_period,
        notification_period => $nagios::var::host_notification_period,
        notes               => $nagios::var::host_notes,
        notes_url           => $nagios::var::host_notes_url,
        tag                 => regsubst($nagios::var::server,'^(.+)$','nagios-\1'),
    }

    # TODO: Remove once all check/*.pp files are updated
    Nagios_service {
        use => 'generic-service,nagiosgraph-service',
    }
    $plugin_dir = $nagios::params::plugin_dir

    # Enable all default checks by... default
    include nagios::defaultchecks

    # The perl bindings are required by multiple packages
    # FIXME: Find a nicer way to avoid duplicate definitions
    if $perl {
        nagios::package { 'nagios-plugins-perl': }
    }

    # With selinux, many nrpe plugins require additional rules to work
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'nrpe':
            source => 'puppet:///modules/nagios/messages.nrpe',
        }
    }

}

