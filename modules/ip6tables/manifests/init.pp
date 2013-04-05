# This definition manages the ip6tables IPv6 iptables rules.
#
# Sample Usage :
#     ip6tables { '/etc/sysconfig/ip6tables':
#         tcpports => [ '80', '443' ],
#     }
#
define ip6tables (
    # Options related to ip6tables
    $ethpub             = 'eth0',
    $ethpriv            = 'eth1',
    $chains_filter      = {},
    $fwmark             = {},
    $protectpriv        = false,
    $vrrp               = [],
    $ospf               = [],
    $tcpports           = [],
    $udpports           = [],
    $lsnraddrs          = [],
    $sipaddrs           = [],
    $privtcpports       = [],
    $privudpports       = [],
    $srctcpports        = {},
    $srcudpports        = {},
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
    # Options related to ip6tables-config (RHEL/Fedora)
    $modules            = '',
    $modules_unload     = 'yes',
    $save_on_stop       = 'no',
    $save_on_restart    = 'no',
    $save_counter       = 'no',
    $status_numeric     = 'yes',
    $status_verbose     = 'no',
    $status_linenumbers = 'yes',
    $sysctl_load_list   = undef,
    # Options related to conf.d/ip6tables (Gentoo only)
    $ip6tables_save     = '/var/lib/ip6tables/rules-save',
    $save_restore_options = ''  # default is "-c"
    #$save_on_stop      = 'no'  # see above, original default is "yes"
) {

    include ip6tables::params

    # Main package
    if $ip6tables::params::package {
        package { $ip6tables::params::package:
            before => Service[$ip6tables::params::service],
            ensure => installed,
        }
    }

    # The module name and option names have changed
    if $iptables::params::ctstate == true {
        $mstate = '-m conntrack --ctstate'
    } else {
        $mstate = '-m state --state'
    }

    # Configuration files
    file { $ip6tables::params::rules:
        notify  => Service[$ip6tables::params::service],
        mode    => '0600',
        content => template('ip6tables/ip6tables.erb'),
    }
    if $ip6tables::params::config == '/etc/sysconfig/ip6tables-config' {
        file { $ip6tables::params::config:
            notify  => Service[$ip6tables::params::service],
            mode    => '0600',
            content => template('ip6tables/ip6tables-config.erb'),
        }
    } elsif $ip6tables::params::config == '/etc/conf.d/ip6tables' {
        file { $ip6tables::params::config:
            notify  => Service[$ip6tables::params::service],
            mode    => '0644',
            content => template('ip6tables/conf.d-ip6tables.erb'),
        }
    }

    # Run sysctl since conntrack values can be reset when modules are reloaded
    service { $ip6tables::params::service:
        enable    => true,
        ensure    => running,
        restart   => $ip6tables::params::restart,
        hasstatus => true,
    }

}

