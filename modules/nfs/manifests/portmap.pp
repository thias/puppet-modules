# Class: nfs::portmap
#
class nfs::portmap {

    package { [ 'portmap' ]: ensure => installed }

    service { 'portmap':
        alias     => 'rpcbind',
        require   => [ Package['portmap'], Package['nfs-utils'] ],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

}

