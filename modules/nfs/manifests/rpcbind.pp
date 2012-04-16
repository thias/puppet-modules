# Class: nfs::rpcbind
#
class nfs::rpcbind {

    package { [ 'rpcbind' ]: ensure => installed }

    service { 'rpcbind':
        require   => [ Package['rpcbind'], Package['nfs-utils'] ],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

}

