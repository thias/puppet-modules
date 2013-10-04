# Class: percona::params
#
class percona::params {

    case $::operatingsystem {
        'Fedora', 'RedHat', 'CentOS': {
            include percona::yumrepo
            # Include this client, otherwise an older one can be pulled in
            $package = [
                'Percona-Server-shared-51',
                'Percona-Server-client-51',
                'Percona-Server-server-51',
            ]
            $package_require = Class['percona::yumrepo']
        }
        default: {
            $package = 'Percona-XtraDB-Cluster-server'
        }
    }

}

