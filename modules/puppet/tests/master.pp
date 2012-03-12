include puppet::agent
class { 'puppet::master':
    reports      => 'http',
    storeconfigs => true,
}
