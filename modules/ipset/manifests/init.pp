# Define: ipset
#
# Create and manage ipsets. You must pass one of $from_file, ... TODO, unless
# you are passing "ensure => absent" to remove the ipset.
#
# Parameters:
#  $from_file:
#    Create and manage the ipset from the content of a file. Default: none
#  $ipset_type:
#    The type of the ipset. Default: hash:ip
#  $ipset_create_options:
#    The create options of the ipset. Default: empty
#  $ipset_add_options:
#    The add options of the ipset elements. Default: empty
#
# Sample Usage:
#  file { '/path/to/my_blacklist.txt': content => "10.0.0.1\n10.0.0.2\n" }
#  ipset::test { 'my_blacklist':
#      from_file => '/path/to/my_blacklist.txt',
#  }
#
define ipset (
    $from_file = false,
    $ipset_type = 'hash:ip',
    $ipset_create_options = '',
    $ipset_add_options = '',
    $ensure = undef
) {

    # Even for "absent", since it requires the tool to work
    include ipset::base

    if $ensure == 'absent' {
        exec { "/usr/sbin/ipset destroy ${title}":
            onlyif => "/usr/sbin/ipset list ${title} &>/dev/null",
        }
    } else {

        # Run in the from_file mode (the only one implemented initially
        if $from_file {
            exec { "ipset-test-${title}":
                command     => "/usr/local/sbin/ipset_from_file -n ${title} -f ${from_file} -t \"${ipset_type}\" -c \"${ipset_create_options}\" -a \"${ipset_add_options}\"",
                subscribe   => File[$from_file],
                refreshonly => true,
            }
        }

    }

}

