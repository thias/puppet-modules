# Squid 3.x proxy server.
#
# Sample Usage :
#     include squid3
#
#     class { 'squid3':
#         acl => [
#             'de myip 192.168.1.1',
#             'fr myip 192.168.1.2',
#             'office src 10.0.0.0/24',
#         ],
#         http_access => [
#             'allow office',
#         ],
#         cache => [ 'deny all' ],
#         via => 'off',
#         tcp_outgoing_address => [
#             '192.168.1.1 country_de',
#             '192.168.1.2 country_fr',
#         ],
#         server_persistent_connections => 'off',
#     }
#
class squid3 (
    # For RHEL5 this is 'squid3'
    $rpmname              = 'squid',
    # Options are in the same order they appear in squid.conf
    $http_port            = [ '3128' ],
    $acl                  = [],
    $http_access          = [],
    $icp_access           = [],
    $tcp_outgoing_address = [],
    $cache_mem            = '256 MB',
    $cache_dir            = [],
    $access_log           = [ '/var/log/squid/access.log squid' ],
    $cache_log            = '/var/log/squid/cache.log',
    $cache                = [],
    $cache_store_log      = '/var/log/squid/store.log',
    $cache                = [],
    $via                  = 'on',
    $ignore_expect_100    = 'off',
    $cache_mgr            = 'root',
    $client_persistent_connections = 'on',
    $server_persistent_connections = 'on',
    $forwarded_for        = 'on'
) {

    package { $rpmname: ensure => installed }

    service { 'squid':
        require   => Package[$rpmname],
        enable    => true,
        ensure    => running,
        restart   => '/sbin/service squid reload',
        hasstatus => true,
    }

    file { '/etc/squid/squid.conf':
        require => Package[$rpmname],
        notify  => Service['squid'],
        content => template('squid3/squid.conf.erb'),
    }

}

