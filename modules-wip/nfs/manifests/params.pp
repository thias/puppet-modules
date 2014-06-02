# Class: nfs::params
#
class nfs::params {

  case $::osfamily {
    'RedHat': {
      if $::operatingsystemrelease >= 7 {
        $service_nfs     = 'nfs-server'
        $service_idmapd  = 'nfs-idmap'
        $service_lockd   = 'nfs-lock'
        #$service_mountd  = 'nfs-mountd'
        #$service_rquotad = 'nfs-rquotad'
      } else {
        $service_nfs     = 'nfs'
        $service_idmapd  = 'rpcidmapd'
        $service_lockd   = 'nfslock'
        #$service_mountd  = ''
        #$service_rquotad = ''
      }
    }
    default: {
      fail("The osfamily ${::osfamily} isn't supported.")
    }
  }

}

