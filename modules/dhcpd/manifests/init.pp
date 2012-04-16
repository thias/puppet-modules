# Class: dhcpd
#
# Installs and enables a dhcpd server.
#
# Parameters:
#  $configsource:
#    Puppet location of the configuration file to use. Mandatory.
#  $dhcpdargs:
#    Command-line arguments to be added to dhcpd. Default: empty
#  $ensure:
#    Ensure parameter for the service. Default: undefined
#  $enable:
#    Enable parameter for the service. Default: true
#
# Sample Usage :
#  class { 'dhcpd':
#      configsource => 'puppet:///files/dhcpd.conf-foo',
#      # Restrict listening to a single interface
#      dhcpdargs    => 'br1',
#      # Default is to enable but allow to be stopped (for active/passive)
#      ensure       => 'running',
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

