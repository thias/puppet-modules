package { 'nfs-utils': ensure => installed }
include nfs::rpcbind
