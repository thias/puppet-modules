iptables { "/etc/sysconfig/iptables":
    tcpports  => [ "53", "80", "443" ],
    udpports  => [ "53" ],
    hosts_ssh => [ "192.0.2.1" ],
    knock     => true,
    knockone  => "1111",
    knocktwo  => "2222",
    nat       => true,
    masq      => true,
    redirect_tcp_port => {
        '80'  => "8080",
        '443' => "8443",
    },
}
