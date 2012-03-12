class { 'puppet::agent':
    forcenoop     => true,
    service       => false,
    cron_enable   => true,
    cron_silent   => true,
    puppet_server => 'puppet.example.com',
}
