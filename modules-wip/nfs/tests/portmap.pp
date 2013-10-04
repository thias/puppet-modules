package { 'nfs-utils': ensure => installed }
include nfs::portmap
