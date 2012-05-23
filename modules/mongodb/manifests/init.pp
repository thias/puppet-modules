# Class: mongodb
#
# Install, enable and configure the MongoDB scalable, high-performance NoSQL
# database.
#
# Parameters:
#  See the comments in the included mongodb.conf.
#
# Sample Usage :
#  include mongodb
#  class { 'mongodb':
#      bind_ip => '0.0.0.0',
#      verbose => 'true',
#  }
#
class mongodb (
    # Just in case you wonder : quoted 'false' is for true/false text to be
    # set in the configuration file, unquoted false is enable+value/disable
    # a feature.
    $logpath        = '/var/log/mongodb/mongodb.log',
    $bind_ip        = '127.0.0.1',
    $port           = '27017',
    $dbpath         = '/var/lib/mongodb',
    $auth           = 'false',
    $verbose        = 'false',
    $objcheck       = 'false',
    $quota          = 'false',
    $oplog          = '0',
    $slave          = 'false',
    $master         = 'false',
    $source         = false,
    $pairwith       = false,
    $arbiter        = false,
    $autoresync     = false,
    $oplogSize      = false,
    $opIdMem        = false
) {

    # Main package and service
    package { 'mongodb-server': ensure => installed }
    service { 'mongod':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        subscribe => File['/etc/mongodb.conf'],
        require   => Package['mongodb-server'],
    }

    # Main configuration file
    file { '/etc/mongodb.conf':
        content => template('mongodb/mongodb.conf.erb'),
        require => Package['mongodb-server'],
    }

}

