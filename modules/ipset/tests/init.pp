file { '/tmp/test-iplist.txt':
    source => "puppet:///modules/${module_name}/test-iplist.txt",
}
ipset { 'foo':
    from_file => '/tmp/test-iplist.txt',
}
ipset { 'bar': ensure => absent }
