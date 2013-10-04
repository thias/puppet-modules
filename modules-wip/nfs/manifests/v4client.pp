# Class: nfs::v4client
#
class nfs::v4client (
    $idmapd_domain = $::domain,
    $secure_nfs    = false
) inherits nfs::common-client {

    include nfs::rpcbind
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
        require   => Service['rpcbind'],
        enable    => false,
        ensure    => stopped,
        # Returns zero even when stopped :-(
        hasstatus => false,
        status    => '/sbin/pidof rpc.statd',
    }

    # This is a bit ugly...
    if $secure_nfs {
        file { '/etc/sysconfig/nfs':
            content => "SECURE_NFS=\"yes\"\n",
            require => Package['nfs-utils'],
        }
        service { 'rpcgssd':
            enable    => true,
            ensure    => running,
            hasstatus => true,
            # Only starts once the SECURE_NFS is set
            subscribe => File['/etc/sysconfig/nfs'],
        }
    }

}

