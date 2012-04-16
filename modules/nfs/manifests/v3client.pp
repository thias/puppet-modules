# Class: nfs::v3client
#
class nfs::v3client inherits nfs::common-client {

    if ( $::operatingsystem == 'RedHat' and $::operatingsystemrelease < 6 ) {
        include nfs::portmap
    } else {
        include nfs::rpcbind
    }
    service { 'nfslock':
        require => Service['rpcbind'],
        enable  => true,
        ensure  => running,
        # Returns zero even when stopped :-(
        #hasstatus => true,
        status  => '/sbin/pidof rpc.statd',
    }

}

