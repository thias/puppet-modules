define nagios::check::couchbase (
    $ensure = undef,
    $args = '',
    $couchbase_data_file_name = '/tmp/couchbase_data_file_name',
    $couchbase_cbstats = '/opt/couchbase/bin/cbstats',
    $couchbase_host = '127.0.0.1',
    $couchbase_port = '11211'
) {

    # Generic overrides
    if $::nagios_check_couchbase_check_period != '' {
        Nagios_service { check_period => $::nagios_check_couchbase_check_period }
    }
    if $::nagios_check_couchbase_notification_period != '' {
        Nagios_service { notification_period => $::nagios_check_couchbase_notification_period }
    }

    # Service specific overrides
    if $::nagios_check_couchbase_args != '' {
        $fullargs = $::nagios_check_couchbase_args
    } else {
        $fullargs = $args
    }

    file { "${nagios::client::plugin_dir}/check_couchbase":
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('nagios/plugins/check_couchbase.erb'),
        ensure  => $ensure,
    }

    nagios::client::nrpe_file { 'check_couchbase':
        args    => $fullargs,
        ensure  => $ensure,
    }

    nagios::service { "check_couchbase_${title}":
        check_command       => 'check_nrpe_couchbase',
        service_description => 'couchbase',
        #servicegroups       => 'couchbase',
        ensure              => $ensure,
    }

}

