# Class: ovh::oco::daemon
#
# Install the OvhCheckOut package and enable the included service (a cron job).
# Note that TCP port 79 needs to be open for at least some OVH networks for
# OvhCheckOut to work.
# Using the ovh::oco::check definition will typically take care of
# including this class, so only explicitly include it of you don't plan on
# using the check definition.
#
# Parameters:
#  none
#
# Sample Usage :
#  include ovh::oco::daemon
#
class ovh::oco::daemon {
    package { 'oco': ensure => installed }
    service { 'oco':
        ensure    => running,
        require   => Package['oco'],
        enable    => true,
        hasstatus => true,
    }
}

