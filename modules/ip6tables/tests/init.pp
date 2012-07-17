ip6tables { '/etc/sysconfig/iptables':
    ethpub       => 'br0',
    ethpriv      => 'br1',
    tcpports     => [ '53', '80', '443' ],
    udpports     => [ '53' ],
    privtcpports => [ '3306' ],
    hosts_ssh    => [ 'fe80::223:aeff:fe75:1302' ],
    knock        => true, knockone => '1111', knocktwo => '2222',
}
