# Class: tuned
#
# The tuned adaptative system tuning daemon.
#
# Parameters:
#  $profile:
#    The tuned profile to use. Default: 'default'
#
# Sample Usage :
#  include tuned
#  class { 'tuned': profile => 'virtual-host' }
#
class tuned (
    $profile = 'default'
) {

    # One package, two services
    package { 'tuned': ensure => installed }
    service { [ 'tuned', 'ktune' ]:
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['tuned'],
    }

    # Enable the chosen profile
    exec { "/usr/sbin/tuned-adm profile ${profile}":
        unless => "/usr/sbin/tuned-adm active | /bin/grep -q -e '^Current active profile: ${profile}\$'",
        notify => [ Service['tuned'], Service['ktune'] ],
    }

}

