# Class: iptables::params
#
# Parameters for the iptables module.
#
# Parameters:
#  none
#
# Sample Usage:
#  include iptables::params
#
class iptables::params {
    # The easy bunch
    $service = 'iptables'
    # Package and save file
    case $::operatingsystem {
        'Gentoo': {
            $package = 'net-firewall/iptables'
            $rules   = '/var/lib/iptables/rules-save'
            $config  = '/etc/conf.d/iptables'
            $restart = '/etc/init.d/iptables restart'
            $ctstate = true
        }
        default: {
            $package = 'iptables'
            $rules   = '/etc/sysconfig/iptables'
            $config  = '/etc/sysconfig/iptables-config'
            # Since sysctl often fails, make sure we ignore it
            $restart = '/sbin/service iptables restart; RETVAL=$?; /sbin/sysctl -p; exit $RETVAL'
            $ctstate = false
        }
    }
}

