class { 'dhcpd':
    # Bogus, we just need a file
    configsource => 'puppet:///modules/dhcpd/dhcpd.conf-example',
    dhcpdargs    => 'br1',
    ensure       => 'running',
}

