ipset::iptables { 'mylist':
    chain   => 'INPUT',
    options => '-p tcp',
    target  => 'REJECT',
}
ipset::iptables { 'mylist-log':
    table   => 'raw',
    chain   => 'PREROUTING',
    ipset   => 'mylist',
    options => '-p tcp --dport 80',
    target  => 'LOG --log-prefix "MyList: "',
}
