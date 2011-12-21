# DHCP module.
#
# Sample Usage :
#     class { 'dhcpd':
#         configsource => 'puppet:///files/dhcpd.conf-foo',
#         # Restrict listening to a single interface
#         dhcpdargs    => 'br1',
#     }
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

    file { '/etc/dhcp/dhcpd.conf':
        source  => $configsource,
        require => Package['dhcp'],
        notify  => Service['dhcpd'],
    }

}

