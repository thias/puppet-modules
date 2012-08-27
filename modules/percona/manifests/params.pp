# Class: percona::params
#
class percona::params {

    case $::operatingsystem {
        'Gentoo': {
            $package = 'dev-db/xtrabackup'
        }
        'Fedora', 'RedHat', 'CentOS': {
            include percona::yumrepo
            $package = 'percona-xtrabackup'
            $package_require = Class['percona::yumrepo']
        }
        default: {
            $package = 'percona-xtrabackup'
        }
    }

}

