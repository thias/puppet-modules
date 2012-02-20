# Class to access all nagios related variables, the defaults or overriden
# using facts created by nagios::client::config.
#
class nagios::var {

    # For the tag of host/service stored configurations
    if $::nagios_server != '' {
        $server = $::nagios_server
    } else {
        $server = 'default'
    }
    # Values used for nagios_host
    if $::nagios_host_name != '' {
        $host_name = $::nagios_host_name
    } else {
        $host_name = $::fqdn
    }
    if $::nagios_host_alias != '' {
        $host_alias = $::nagios_host_alias
    } else {
        $host_alias = $::fqdn
    }
    if $::nagios_host_address != '' {
        $host_address = $::nagios_host_address
    } else {
        $host_address = $ipaddress
    }
    if $::nagios_host_use != '' {
        $host_use = $::nagios_host_use
    } else {
        $host_use = 'linux-server'
    }
    # TODO: hostgroups
    # TODO: icon_image
    # TODO: statusmap_image
    if $::nagios_host_notes != '' {
        $host_notes = $::nagios_host_notes
    } else {
        $host_notes = "<table><tr><th>OS</th><td>${::operatingsystem} ${::operatingsystemrelease}</td></tr><tr><th>CPU</th><td>${::physicalprocessorcount} x ${::processor0}</td></tr><tr><th>Architecture</th><td>${::architecture}</td></tr><tr><th>Kernel</th><td>${::kernelrelease}</td></tr><tr><th>Memory</th><td>${::memorysize}</td></tr><tr><th>Swap</th><td>${::swapsize}</td></tr></table>"
    }
    if $::nagios_host_notes_url != '' {
        $host_notes_url = $::nagios_host_notes_url
    } else {
        $host_notes_url = "/nagios/cgi-bin/status.cgi?host=${host_name}"
    }

    # check_period
    if $::nagios_check_period != '' {
        $check_period = $::nagios_check_period
    } else {
        $check_period = '24x7'
    }

    # notification_period
    if $::nagios_notification_period != '' {
        $notification_period = $::nagios_notification_period
    } else {
        $notification_period = '24x7'
    }

    # hostgroups (defaults to undef)
    if $::nagios_hostgroups != '' {
        $hostgroups = $::nagios_hostgroups
    }

    # contactgroups (defaults to undef)
    if $::nagios_contactgroups != '' {
        $contactgroups = $::nagios_contactgroups
    }

}

