# Nginx web server module.
#
# Sample Usage :
#     include nginx
#
class nginx (
    $remove_default_conf = true,
    # Main options
    $env = [],
    # HTTP module options
    $user = 'nginx',
    $worker_processes = '1',
    $worker_rlimit_nofile = false,
    $worker_connections = '1024',
    $default_type = 'application/octet-stream',
    $sendfile = 'on',
    $tcp_nopush = 'off',
    $keepalive_timeout = '65',
    $keepalive_requests = '100',
    $send_timeout = '60',
    $log_not_found = 'off',
    $server_tokens = 'off',
    $server_name_in_redirect = 'off',
    $server_names_hash_bucket_size = '64',
    $gzip = 'on',
    $gzip_min_length = '0',
    $gzip_types = 'text/plain',
    $geoip_country = false,
    $geoip_city = false,
    $index = 'index.html',
    # Module options
    $autoindex = 'off',
    # Template options
    $listen_http = [ '80' ],
    $listen_https = [ '443' ]
) {

    package { 'nginx': ensure => installed }

    service { 'nginx':
        enable    => true,
        ensure    => running,
        restart   => '/sbin/service nginx reload',
        hasstatus => true,
        require   => Package['nginx'],
    }

    # Main configuration file
    file { '/etc/nginx/nginx.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('nginx/nginx.conf.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    }

    # Default configuration file included in the package (usually unwanted)
    if $remove_default_conf {
        file { '/etc/nginx/conf.d/default.conf':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => '# Empty, not removed, to not reappear when the package is updated.\n',
            require => Package['nginx'],
        }
    }

}

