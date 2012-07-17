# Define: rhel::net::ifalias
#
# Create and start network interface aliases. The definition title is the
# interface name.
#
# Parameters:
#  $ipaddr:
#    Interface IPv4 address. Default: none
#  $netmask:
#    Interface IPv5 network mask. Default: none
#
# Sample Usage:
#  rhel::net::ifalias { 'eth0:0':
#      ipaddr => '10.0.0.1', netmask => '255.255.255.0',
#  }
#
define rhel::net::ifalias (
    $ipaddr  = '',
    $netmask = ''
) {

    file { "/etc/sysconfig/network-scripts/ifcfg-${title}":
        content => template('rhel/net/ifalias.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    exec { "ifdown ${title}; ifup ${title}":
        path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        subscribe   => File["/etc/sysconfig/network-scripts/ifcfg-${title}"],
        refreshonly => true,
    }

}

