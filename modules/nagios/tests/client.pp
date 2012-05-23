class { 'nagios::client':
    service_use => 'generic-service,nagiosgraph-service',
}
