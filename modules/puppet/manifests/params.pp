# Class: puppet::params
#
class puppet::params {
  case $::operatingsystem {
    'Fedora',
    'RedHat',
    'CentOS': { $sysconfig = true }
     default: { $sysconfig = false }
  }
}

