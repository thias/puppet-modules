# Class: couchbase::server
#
# Couchbase Server.
#
# Parameters:
#  $rpmbasename, $rpmbaseurl:
#    Used for Gentoo only, since the upstream rpm package is extracted.
#
# Sample Usage :
#  include couchbase::server
#
class couchbase::server (
    $rpmbasename = $couchbase::params::rpmbasename,
    $rpmbaseurl  = $couchbase::params::rpmbaseurl
) inherits couchbase::params {

    class { 'couchbase::install':
        rpmbasename => $rpmbasename,
        rpmbaseurl  => $rpmbaseurl,
    }

    service { 'couchbase-server':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Class['couchbase::install'],
    }

}

