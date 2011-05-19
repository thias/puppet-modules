# Enable the OVH ssh key from cache.ovh.net, usually for the root account.
# This is required for OVH support to perform advanced diagnostics on their
# cuscomer's servers.
#
# Sample Usage :
#    ovh::sshkey { "root": options => [] }
#    ovh::sshkey { "root": ensure => absent}
#
define ovh::sshkey (
    $ensure = "present",
    $options = [ "from=\"213.186.50.100,::ffff:213.186.50.100\"" ]
) {

    ssh_authorized_key { "ovh-root":
        key => "AAAAB3NzaC1yc2EAAAABIwAAAIEAt3XaIhEoRK5sEKm6wtYyazLOx3w+Yv9+bpfEvLftHr2hxZ2TY2A655iwMbgvhHqsMuGEjK9yGkZIQbUgB6HvOgOWOwJSX6Gc9Ac7GuH11xSU8tHDuTQot6fVtgcm2Y/VUFi65Knz9rLHz7h/Zy29ek+UYav5T7juhBIuk57cDxs=",
        type => "rsa",
        user => $title,
        options => $options,
        ensure => $ensure,
    }

}

