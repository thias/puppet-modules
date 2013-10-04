# Class: ip6tables::params
#
# Parameters for the ip6tables module.
#
# Parameters:
#  none
#
# Sample Usage:
#  include ip6tables::params
#
class ip6tables::params {
    # The easy bunch
    $service = 'ip6tables'
    # Package and save file
    case $::operatingsystem {
        'Gentoo': {
            $package = false
            $rules   = '/var/lib/ip6tables/rules-save'
            $config  = '/etc/conf.d/ip6tables'
            $restart = '/etc/init.d/ip6tables restart'
            $ctstate = true
        }
        default: {
            # Has been merged back into iptables in Fedora (somewhere < 17)
            #$package = 'iptables-ipv6'
            $rules   = '/etc/sysconfig/ip6tables'
            $config  = '/etc/sysconfig/ip6tables-config'
            # Since sysctl often fails, make sure we ignore it
            $restart = '/sbin/service ip6tables restart; RETVAL=$?; /sbin/sysctl -p; exit $RETVAL'
            $ctstate = false
        }
    }
}

