# Class: nfs::v4client
#
class nfs::v4client (
    $idmapd_domain = $::domain
) inherits nfs::common-client {

    if ( $::operatingsystem == 'RedHat' and $::operatingsystemrelease < 6 ) {
        include nfs::portmap
    } else {
        include nfs::rpcbind
    }
    service { 'rpcidmapd':
        require   => Package['nfs-utils'],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }
    file { '/etc/idmapd.conf':
        require => Package['nfs-utils'],
        content => template('nfs/idmapd.conf.erb'),
    }
    service { 'nfslock':
        require => Service['rpcbind'],
        enable  => false,
        ensure  => stopped,
        # Returns zero even when stopped :-(
        #hasstatus => true,
        status  => '/sbin/pidof rpc.statd',
    }

}

