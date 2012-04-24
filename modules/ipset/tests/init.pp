file { '/tmp/test-iplist.txt':
    source => 'puppet:///modules/ipset/test-iplist.txt',
}
ipset { 'foo':
    from_file => '/tmp/test-iplist.txt',
}
ipset { 'bar': ensure => absent }
