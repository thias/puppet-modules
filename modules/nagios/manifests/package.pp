# Wrapper around package names, since we can't have multiple 'alias' for a
# single package, nor can we have multiple packages with the same 'name'
#
define nagios::package () {

    case $title {
        # Plugins provided by the main nagios-plugins package
        /^nagios-plugins-(apt|breeze|by_ssh|cluster|dhcp|dig|disk_smb|disk|dns|dummy|file_age|flexlm|fping|hpjd|http|icmp|ide_smart|ifoperstatus|ifstatus|ircd|ldap|linux_raid|load|log|mailq|mrtgtraf|mrtg|mysql|nagios|ntp|nt|nwstat|oracle|overcr|perl|pgsql|ping|procs|radius|real|rpc|sensors|smtp|snmp|ssh|swap|tcp|time|udp|ups|users|wave)$/:
            {
                $pkgname = $::operatingsystem ? {
                    'Gentoo' => 'net-analyzer/nagios-plugins',
                    'RedHat' => $title,
                }
                realize Package[$pkgname]
            }
    }

}

