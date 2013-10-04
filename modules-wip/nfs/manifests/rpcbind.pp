# Class: nfs::rpcbind
#
# Also supports legacy 'portmap' package and service.
#
class nfs::rpcbind {

    if ( $::operatingsystem == 'RedHat' and $::operatingsystemrelease < 6 ) {
        $myname = 'portmap'
    } else {
        $myname = 'rpcbind'
    }

    package { $myname: ensure => installed }

    service { $myname:
        require   => [ Package[$myname], Package['nfs-utils'] ],
        enable    => true,
        ensure    => running,
        hasstatus => true,
        alias     => 'rpcbind',
    }

}

