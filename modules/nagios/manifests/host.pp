# Testing, 1... 2... 3...
#
# Wrap around the original nagios_host :
# * To be able to export with the default tag
# * To be able to use defaults set by the module
#
define nagios::host (
    $address,
    $alias               = $name,
    $use                 = $nagios::var::host_use,
    $hostgroups          = $nagios::var::hostgroups,
    $contact_groups      = $nagios::var::contactgroups,
    $check_period        = $nagios::var::check_period,
    $notification_period = $nagios::var::notification_period,
    # Our default is hardware specs of the main host, so exclude
    $notes               = undef,
    # Our default is a link with the main hostname, so exclude
    $notes_url           = undef
) {

    @@nagios_host { $title:
        address             => $address,
        alias               => $alias,
        use                 => $use,
        hostgroups          => $hostgroups,
        contact_groups      => $contact_groups,
        check_period        => $check_period,
        notification_period => $notification_period,
        notes               => $notes,
        notes_url           => $notes_url,
        tag                 => "nagios-${nagios::var::server}",
    }

}

