# This class installs the xinetd package and enables the main xinetd service.
#
# It isn't meant to be used on its own, as it is automatically included by the
# more specific service related definitions of the module.
#
# Sample Usage :
#    include xinetd
#
class xinetd {

    package { "xinetd": ensure => installed }

    service { "xinetd":
        require   => Package["xinetd"],
        enable    => true,
        ensure    => running,
        restart   => "/sbin/service xinetd reload",
        # on RHEL5 "xinetd is stopped" has an exit status of 0...
        #hasstatus => true,
    }

}

