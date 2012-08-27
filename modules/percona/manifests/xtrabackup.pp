# Class: percona::xtrabackup
#
# Install the Percona XtraBackup tool.
#
# Parameters:
#  $ensure:
#    Whether XtraBackup should be 'present' or 'absent'. Default: 'present'
#
# Sample Usage :
#  include percona::xtrabackup
#
class percona::xtrabackup inherits percona::params {

    if $ensure != 'absent' {
        # Package
        include percona::yumrepo
        package { $percona::params::package:
            ensure  => installed,
            require => $percona::params::package_require,
        }
    } else {
        # We can't remove the repo since other resources could require it
        package { $percona::params::package: ensure => absent }
    }

}

