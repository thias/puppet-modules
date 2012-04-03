# Class: nginx
#
# Install, enable and configure an NGINX web server.
#
# Parameters:
#  $remove_default_conf:
#    Remove default configuration which gets in the way. Default: true for
#    RHEL/Fedora and variants, false otherwise (non applicable)
#  $env:
#    Array of environment variables NAME=value to set globally. Default: none
#  $user:
#    System user to run as. Default: nginx
#  $worker_processes:
#    Number of system worker processes. Default: processorcount fact value
#  $worker_rlimit_nofile:
#    Change the maximum allowed number of open files on startup. Default: use
#    the system's default.
#  $worker_connections:
#    Maximum number of connections per worker. Default: 1024.
#  $default_type:
#    MIME type for files with none set by the main mime.types file. Default:
#    application/octet-stream.
#  $sendfile: Default: on
#  $tcp_nopush: Default: off
#  $keepalive_timeout: Default: 65
#  $keepalive_requests: Default: 100
#  $send_timeout: Default: 60
#  $log_not_found: Default: off
#  $server_tokens: Default: off
#  $server_name_in_redirect: Default: off
#  $server_names_hash_bucket_size: Default: 64
#  $gzip: Default: on
#  $gzip_min_length: Default: 0
#  $gzip_types: Default: text/plain
#  $geoip_country = Default: false
#  $geoip_city = Default: false
#  $index: Default: index.html
#  $autoindex: Default: off
#
# Sample Usage :
#  include nginx
#  class { 'nginx':
#  }
#
class nginx (
    $remove_default_conf = $nginx::params::remove_default_conf,
    # Main options
    $env = [],
    # HTTP module options
    $user = $nginx::params::user,
    $worker_processes = $::processorcount,
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
    $autoindex = 'off'
) inherits nginx::params {

    package { $nginx::params::package:
        alias  => 'nginx',
        ensure => installed,
    }

    service { $nginx::params::service:
        enable    => true,
        ensure    => running,
        restart   => '/sbin/service nginx reload',
        hasstatus => true,
        require   => Package['nginx'],
        alias     => 'nginx',
    }

    # Main configuration file
    file { "${confdir}/nginx.conf":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('nginx/nginx.conf.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    }

    # Default configuration file included in the package (usually unwanted)
    if $remove_default_conf {
        file { "${confdir}/conf.d/default.conf":
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => '# Empty, not removed, to not reappear when the package is updated.\n',
            require => Package['nginx'],
        }
    }

}

