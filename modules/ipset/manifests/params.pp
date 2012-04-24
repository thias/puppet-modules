# Class ipset::params
#
# Parameters for ipset.
#
# Parameters:
#  none
#
# Sample Usage:
#  include ipset::params
#
class ipset::params {

    $package = $::operatingsystem ? {
        'Gentoo' => 'net-firewall/ipset',
         default => 'ipset',
    }

}

