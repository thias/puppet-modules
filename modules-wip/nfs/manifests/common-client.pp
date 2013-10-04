# Class: nfs::common-client
#
class nfs::common-client {

    package { 'nfs-utils': ensure => installed }
    service { 'netfs': enable => true }

}

