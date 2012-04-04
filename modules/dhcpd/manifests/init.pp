# Class: dhcpd
#
# Sample Usage :
#  class { 'dhcpd':
#      configsource => 'puppet:///files/dhcpd.conf-foo',
#      # Restrict listening to a single interface
#      dhcpdargs    => 'br1',
#  }
#
class dhcpd (
    $configsource,
    $dhcpdargs = '',
    $ensure = undef,
    $enable = true
) {

    package { 'dhcp': ensure => installed }

    service { 'dhcpd':
        ensure    => $ensure,
        enable    => $enable,
        hasstatus => true,
        require   => Package['dhcp'],
    }

    file { '/etc/sysconfig/dhcpd':
        content => template('dhcpd/dhcpd.sysconfig.erb'),
        notify  => Service['dhcpd'],
    }

    if $::operatingsystemrelease < 6 {
        $dhcpd_conf = '/etc/dhcpd.conf'
    } else {
        $dhcpd_conf = '/etc/dhcp/dhcpd.conf'
    }
    file { $dhcpd_conf :
        source  => $configsource,
        require => Package['dhcp'],
        notify  => Service['dhcpd'],
    }

}

