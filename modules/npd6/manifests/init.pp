# Class: npd6
#
# Install, configure and enable the Neighbor Proxy Daemon for IPv6.
#
# Parameters:
#  $prefix:
#    The IPv6 prefix to answer neighbor solicitations for. Mandatory.
#  $interface:
#    The network interface on which to listen. Default: 'eth0'
#  $listtype,
#  $addrlist,
#  $collecttargets,
#  $linkoption,
#  $ignorelocal,
#  $routerna,
#  $maxhops:
#    Options for /etc/npd6.conf. See npd6.conf(5) for details.
#
# Sample Usage :
#  class { 'npd6':
#    prefix => '2001:aaaa:bbbb:cccc:',
#  }
#
class npd6 (
  $prefix,
  $interface      = 'eth0',
  $listtype       = 'none',
  $addrlist       = [],
  $collecttargets = '100',
  $linkoption     = 'false',
  $ignorelocal    = 'true',
  $routerna       = 'true',
  $maxhops        = '255'
) {

  file { '/etc/npd6.conf':
    content => template('npd6/npd6.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['npd6'],
    require => Package['npd6'],
  }

  package { 'npd6': ensure => installed }
  service { 'npd6':
    enable    => true,
    ensure    => running,
    restart   => '/etc/init.d/npd6 reload',
    hasstatus => true,
    require   => Package['npd6'],
  }

}

