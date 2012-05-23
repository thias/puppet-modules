# Define: iptables
#
# This definition manages the iptables IPv4 rules.
#
# Sample Usage :
#    iptables { '/etc/sysconfig/iptables':
#        ethpub    => 'br0',
#        ethpriv   => 'br1',
#        tcpports  => [ '53', '80', '443' ],
#        udpports  => [ '53' ],
#        hosts_ssh => [ '192.0.2.1' ],
#        knock     => true, knockone => '1111', knocktwo => '2222',
#        masq      => true,
#    }
#
define iptables (
    # Options related to ip6tables
    $ethpub             = 'eth0',
    $ethpriv            = 'eth1',
    $chains_filter      = {},
    $fwmark             = {},
    $protectpriv        = false,
    $vrrp               = false,
    $ospf               = [],
    $tcpports           = [],
    $udpports           = [],
    $lsnraddrs          = [],
    $sipaddrs           = [],
    $privtcpports       = [],
    $privudpports       = [],
    $srctcpports        = {},
    $hosts_ssh          = false,
    $hosts_nrpe         = false,
    $hosts_snmp         = false,
    $openvpn            = false,
    $openvpn_port       = '1194',
    $openvpn_proto      = 'udp',
    $openvpn_host       = [ '127.0.0.1' ],
    $knock              = false,
    $knocktcpopen       = [ '22' ],
    $knockone           = '12345',
    $knocktwo           = '54321',
    $icmp_limit_enable  = true,
    $icmp_limit         = '50/sec',
    $raw_rules_filter   = [],
    $raw_rules_nat      = [],
    $redirect_tcp_port  = {},
    $dnat_tcp_port      = {},
    $masq               = false,
    # Options related to iptables-config
    $modules            = '',
    $modules_unload     = 'yes',
    $save_on_stop       = 'no',
    $save_on_restart    = 'no',
    $save_counter       = 'no',
    $status_numeric     = 'yes',
    $status_verbose     = 'no',
    $status_linenumbers = 'yes'
) {

    include iptables::params

    # Main package
    package { $iptables::params::package: ensure => installed }

    # Configuration files
    file { $iptables::params::rules:
        notify  => Service[$iptables::params::service],
        mode    => '0600',
        content => template('iptables/iptables.erb'),
    }
    if $iptables::params::config {
        file { $iptables::params::config:
            notify  => Service[$iptables::params::service],
            mode    => '0600',
            content => template('iptables/iptables-config.erb'),
        }
    }

    # Run sysctl since conntrack values can be reset when modules are reloaded
    service { $iptables::params::service:
        require   => Package[$iptables::params::package],
        enable    => true,
        ensure    => running,
        restart   => $iptables::params::restart,
        hasstatus => true,
    }

}

