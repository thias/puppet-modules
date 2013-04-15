# Class: ipset::base
#
# Base class for ipset support. Not really useful on its own.
#
# Parameters:
#  none
#
# Sample Usage :
#  include ipset
#
class ipset::base inherits ipset::params {

    # Main package
    package { $ipset::params::package:
        alias  => 'ipset',
        ensure => installed,
    }

    # Custom script
    file { '/usr/local/sbin/ipset_from_file':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/${module_name}/ipset_from_file",
    }

}

