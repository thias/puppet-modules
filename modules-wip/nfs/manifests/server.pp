# Class: nfs::server
#
# Simple nfs-server class, for both v3 and v4
# Sample Usage :
#  class { 'nfs::server':
#      exports_content => "/nfs 192.168.1.0/24(rw,no_root_squash,async)\n",
#  }
#
class nfs::server (
    $exports_source      = undef,
    $exports_content     = undef,
    $mountd_nfs_v1       = 'yes',
    $mountd_nfs_v2       = 'yes',
    $mountd_nfs_v3       = 'yes',
    $nfsv4               = true,
    $rquotad             = '/usr/sbin/rpc.rquotad',
    $rquotad_port        = '875',
    $rquotadopts         = '',
    $lockdarg            = '',
    $lockd_tcpport       = '32803',
    $lockd_udpport       = '32769',
    $rpcnfsdargs         = false,
    $rpcnfsdcount        = '8',
    $rpcmountdopts       = '',
    $mountd_port         = '892',
    $statdarg            = '',
    $statd_port          = '662',
    # Leaving 2020 will actually be the default : random
    $statd_outgoing_port = '2020',
    $statd_ha_callout    = '/usr/local/bin/foo',
    $rpcidmapdargs       = '',
    $secure_nfs          = 'no',
    $rpcgssdargs         = '',
    $rpcsvcgssdargs      = '',
    $idmapd_domain       = $::domain
) {

    package { 'nfs-utils': ensure => installed }

    file { '/etc/exports':
        source  => $exports_source,
        content => $exports_content,
        notify  => Service['nfs'],
    }

    include nfs::rpcbind
    service { 'nfs':
        require   => Service['rpcbind'],
        subscribe => File['/etc/sysconfig/nfs'],
        enable    => true,
        ensure    => running,
        restart   => '/sbin/service nfs reload',
        # Returns zero even when stopped :-(
        #hasstatus => true,
        status    => '/sbin/pidof nfsd',
    }

    # Configuration
    file { '/etc/sysconfig/nfs':
        require => Package['nfs-utils'],
        content => template('nfs/sysconfig-nfs.erb'),
    }

    if $mountd_nfs_v2 == 'no' and $mountd_nfs_v3 == 'no' and $nfsv4 == true {
        # Not needed for NFSv4, stop/disable
        service { 'nfslock':
            require   => Package['nfs-utils'],
            enable    => false,
            ensure    => stopped,
            # Returns zero even when stopped :-(
            hasstatus => false,
            status    => '/sbin/pidof rpc.statd',
        }
    }

    # Mandatory for NFSv4, required for NFSv4 only
    if $nfsv4 == true {
        service { 'rpcidmapd':
            require   => Package['nfs-utils'],
            subscribe => File['/etc/sysconfig/nfs'],
            enable    => true,
            ensure    => running,
            hasstatus => true,
        }
        file { '/etc/idmapd.conf':
            require => Package['nfs-utils'],
            content => template('nfs/idmapd.conf.erb'),
        }
    } else {
        service { 'rpcidmapd':
            require   => Package['nfs-utils'],
            enable    => false,
            ensure    => stopped,
            hasstatus => true,
        }
    }

    # NFSv2/v3 specific
    if $mountd_nfs_v2 == 'yes' or $mountd_nfs_v3 == 'yes' {
        # RHEL4/5 vs. Fedora/RHEL6+
        service { 'nfslock':
            require   => Package['nfs-utils'],
            subscribe => File['/etc/sysconfig/nfs'],
            enable    => true,
            ensure    => running,
            # Returns zero even when stopped :-(
            #hasstatus => true,
            status    => '/sbin/pidof rpc.statd',
        }
    }

    if $secure_nfs == 'yes' {
        service { 'rpcsvcgssd':
            enable    => true,
            ensure    => running,
            hasstatus => true,
            # Only starts once the SECURE_NFS is set
            subscribe => File['/etc/sysconfig/nfs'],
        }
    }

}

