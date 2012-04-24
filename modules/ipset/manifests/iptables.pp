# Define: ipset::iptables
#
# This shouldn't exist. There should be a way to have iptables silently ignore
# rules for non-existing IP sets...
# NOTE: No absent support! Just remove then restart iptables. Also make sure
# you never save iptables rules with IP set rules included, or restore will
# fail when the IP sets don't (yet) exist. That's the whole problem we try to
# solve here.
#
# Parameters:
#  $table:
#   The table to insert the rule into. Default: 'filter'
#  $chain:
#   The chain to indert the rule into. Mandatory.
#  $ipset:
#   The IP set to match against. Default: $name
#    Use it if you are creating more than one iptables rule for the same IP set.
#  $flags:
#   Comma separated list of 'src' and 'dst' specifications. Default: 'src'
#  $options:
#   The options for the inserted rule. Default: empty
#   You will often want to use this.
#  $target:
#   The target used by inserted rule. Default: 'DROP'
#  $strictmatch:
#   Strict match when checking for existing rules. Default: false
#   Enable if you are sure your $options are set properly and you are having
#   problems creating multiple rules for the same IP set.
#
# Sample Usage:
#  ipset::iptables { 'mylist':
#      chain   => 'INPUT',
#      options => '-p tcp',
#      target  => 'REJECT',
#  }
#  ipset::iptables { 'mylist-log':
#      table   => 'raw',
#      chain   => 'PREROUTING',
#      ipset   => 'mylist',
#      options => '-p tcp --dport 80',
#      target  => 'LOG --log-prefix "MyList: "',
#  }
#
define ipset::iptables (
    $table       = 'filter',
    $chain,
    $ipset       = $name,
    $flags       = 'src',
    $options     = '',
    $target      = 'DROP',
    $strictmatch = false
) {

    # The command to insert the rule
    $iptables_rule = "iptables -t ${table} -I ${chain} 1 -m set --match-set ${ipset} ${flags} ${options} -j ${target}"

    # Matching can be tricky if the target has options, especially quoted ones
    $target_name = regsubst($target,'^([^ ]+).*$','\1')
    # Strict vs. looser matching
    if $strictmatch {
        $iptables_match = "iptables-save | egrep \"^-A ${chain} .+ -m set --match-set ${ipset} ${flags} .*${options}.*-j ${target_name}\""
    } else {
        $iptables_match = "iptables-save | egrep \"^-A ${chain} .+ -m set --match-set ${ipset} ${flags} .*-j ${target_name}\""
    }

    # Insert the rule if it's not already there
    exec { $iptables_rule:
        unless  => $iptables_match,
        path    => [ '/sbin/', '/usr/sbin', '/bin', '/usr/bin' ],
        # We need the IP set to be present
        require => Ipset[$ipset],
    }

}

