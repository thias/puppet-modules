# Class: ipa::params
#
# Parameters for and from the ipa module.
#
# Parameters :
#  none
#
# Sample Usage :
#  include nginx::params
#
class ipa::params {

    # The main "ipa" name, used for packages, services, etc.
    case $::operatingsystem {
        'Fedora': { $ipa = 'freeipa' }
         default: { $ipa = 'ipa' }
    }

}

