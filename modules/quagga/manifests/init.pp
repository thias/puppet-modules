# Class: quagga
#
# Quagga routing server.
#
# Parameters:
#  $ospfd_content:
#    Content (typically using a template) for the ospfd.conf file.
#  $ospfd_source:
#    Source location for the ospfd.conf file.
#
# Sample Usage :
#  class { 'quagga':
#      ospfd_content => template('mymodule/quagga/ospfd.conf.erb'),
#  }
#
class quagga (
    $ospfd_content = undef,
    $ospfd_source = undef
) {

    package { 'quagga': ensure => installed }
    service { 'zebra':
        require => Package['quagga'],
        enable  => true,
        ensure  => running,
    }

    # Included protocol-specific services :
    # bgpd
    # ospf6d
    # ospfd
    # ripd
    # ripngd

    if $ospfd_content or $ospfd_source {
        service { 'ospfd':
            require => [ Service['zebra'], File['/etc/quagga/ospfd.conf'] ],
            enable  => true,
            ensure  => running,
        }
        file { '/etc/quagga/ospfd.conf':
            require => Package['quagga'],
            content => $ospfd_content,
            source  => $ospfd_source,
            notify  => Service['ospfd'],
        }
    } else {
        service { 'ospfd':
            require => Package['quagga'],
            enable  => false,
            ensure  => stopped,
        }
        file { '/etc/quagga/ospfd.conf': ensure => absent }
    }

}

