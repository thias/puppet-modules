# Class: samba::params
#
class samba::params {

  case $osfamily {
    'RedHat': { $service = [ 'smb', 'nmb' ] }
    'Debian': { $service = [ 'samba' ] }
     default: { $service = [ 'samba' ] }
  }

}

