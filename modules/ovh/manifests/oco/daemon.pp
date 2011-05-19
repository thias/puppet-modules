# Install the OvhCheckOut package and enable the included service (a cron job).
# Note that TCP port 79 needs to be open for at least some OVH networks for
# OvhCheckOut to work
#
class ovh::oco::daemon {
    package { "oco": ensure => installed }
    service { "oco":
        require   => Package["oco"],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }
}

