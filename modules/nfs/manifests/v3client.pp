# Class: nfs::v3client
#
class nfs::v3client inherits nfs::common-client {

    include nfs::rpcbind
    service { 'nfslock':
        require   => Service['rpcbind'],
        enable    => true,
        ensure    => running,
        # Returns zero even when stopped :-(
        hasstatus => false,
        status    => '/sbin/pidof rpc.statd',
    }

}

