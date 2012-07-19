# Class: couchbase::params
#
# Parameters for and from the couchbase module.
#
# Parameters :
#  none
#
# Sample Usage :
#  include couchbase::params
#
class couchbase::params {
    $rpmbasename = 'couchbase-server-community_x86_64_1.8.0'
    $rpmbaseurl  = 'http://packages.couchbase.com/releases/1.8.0'
    $basedir     = '/opt/couchbase'
}

