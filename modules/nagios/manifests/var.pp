# Class: nagios::var
#
# Access all nagios client related variables, the defaults or overriden using
# facts created by nagios::client::config, accessed using $::nagios::var::
# scoped variables.
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
    if $::nagios_host_hostgroups != '' {
        $host_hostgroups = $::nagios_host_hostgroups
    }
    if $::nagios_host_contact_groups != '' {
        $host_contact_groups = $::nagios_hostcontact_groups
    }

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

    # Values used for nagios_service
#    if $::nagios_service_use != '' {
#        $service_use = $::nagios_service_use
#    }
#    if $::nagios_service_check_period != '' {
#        $service_check_period = $::nagios_service_check_period
#    }
#    if $::nagios_service_notification_period != '' {
#        $service_notification_period = $::nagios_service_notification_period
#    }
#    if $::nagios_service_max_check_attempts != '' {
#        $service_max_check_attempts = $::nagios_service_max_check_attempts
#    }

}

