# This definition manages the ip6tables IPv6 iptables rules.
#
# Sample Usage :
#    ip6tables { "/etc/sysconfig/ip6tables":
#        tcpports => [ "80", "443" ],
#    }
#
define ip6tables (
    # Options related to ip6tables
    $ethpub             = "eth0",
    $ethpriv            = "eth1",
    $protectpriv        = false,
    $vrrp               = false,
    $ospf               = [],
    $tcpports           = [],
    $udpports           = [],
    $lsnraddrs          = [],
    $sipaddrs           = [],
    $privtcpports       = [],
    $privudpports       = [],
    $hosts_ssh          = false,
    $hosts_nrpe         = false,
    $hosts_snmp         = false,
    $openvpn            = false,
    $openvpn_port       = "1194",
    $openvpn_proto      = "udp",
    $openvpn_host       = [ "127.0.0.1" ],
    # The recent module isn't supported by ip6tables (yet?)
    $knock              = false,
    $knocktcpopen       = [ "22" ],
    $knockone           = "12345",
    $knocktwo           = "54321",
    $port_redir_port    = false,
    $http_redir_port    = false,
    $https_redir_port   = false,
    $https_redir        = false,
    $icmp_limit_enable  = true,
    $icmp_limit         = "50/sec",
    $extra_filter_lines = [],
    # Options related to ip6tables-config
    $modules            = "",
    $modules_unload     = "yes",
    $save_on_stop       = "no",
    $save_on_restart    = "no",
    $save_counter       = "no",
    $status_numeric     = "yes",
    $status_verbose     = "no",
    $status_linenumbers = "yes"
) {

    # Main package
    package { "iptables-ipv6": ensure => installed }

    # Configuration files
    file { "${title}":
        notify  => Service["ip6tables"],
        mode    => "0600",
        content => template("ip6tables/ip6tables.erb"),
    }
    file { "${title}-config":
        notify  => Service["ip6tables"],
        mode    => "0600",
        content => template("ip6tables/ip6tables-config.erb"),
    }

    # Run sysctl since conntrack values can be reset when modules are reloaded
    service { "ip6tables":
        require   => Package["iptables-ipv6"],
        enable    => true,
        ensure    => running,
        restart   => "/sbin/service ip6tables restart && /sbin/sysctl -p",
        hasstatus => true,
    }

}

