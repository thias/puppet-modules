# Class: percona::server
#
# Install the Percona XtraDB Cluster Server.
#
# Parameters:
#  $ensure:
#    Whether Percona Server should be 'present' or 'absent'. Default: 'present'
#
# Sample Usage :
#  include percona::server
#  class { 'percona::server': ensure => absent, repo => false }
#
class percona::server (
    $repo   = true,
    $ensure = 'present'
) inherits percona::params {

    if $ensure != 'absent' {
        if $repo { include percona::yumrepo }
        # Package
        package { $percona::params::package:
            ensure  => installed,
            require => $percona::params::package_require,
        }
    } else {
        if $repo { class { 'percona::yumrepo': ensure => absent } }
        package { $percona::params::package: ensure => absent }
    }

}

