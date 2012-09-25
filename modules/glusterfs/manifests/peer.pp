# Define: glusterfs::peer
#
# Simple "gluster peer probe" wrapper. Peers only need to be added on one end.
# Use the $peers option to the glusterfs::server class instead of this
# definition directly.
#
define glusterfs::peer () {

    exec { "/usr/sbin/gluster peer probe ${title}":
        unless  => "/bin/egrep '^hostname.+=${title}$' /var/lib/glusterd/peers/*",
        require => Service['glusterd'],
    }

}

