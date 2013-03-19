# Class: gdnsd
#
# gdnsd is an Authoritative-only DNS server.
#
# Parameters:
#  $ip_nonlocal_bind:
#    Enable net.ipv4.ip_nonlocal_bind=1. Default: false
#
# Sample Usage :
#  include gdnsd
#
class gdnsd (
  $ip_nonlocal_bind = false
) {

  if $ip_nonlocal_bind {
    # With any kind of failover, we will need to bind early
    sysctl { 'net.ipv4.ip_nonlocal_bind':
      value => '1',
      before => Service['gdnsd'],
    }
  }

  package { 'gdnsd': ensure => installed }

  service { 'gdnsd':
    hasstatus => true,
    enable    => true,
    ensure    => running,
    # Make sure the service doesn't get stopped by config problems
    restart   => '/sbin/service gdnsd reload',
    # The main configuration file is mandatory for the service to start
    require   => [ Package['gdnsd'], File['/etc/gdnsd/config'] ],
  }

}

