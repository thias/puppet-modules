# lighttpd server module.
#
# Sample Usage :
#     none
#
class lighttpd (
    # Modules enabled with no conf file (without "mod_" prefix)
    $modules = [],
    # Modules enabled with existing conf.d/*.conf file (without "mod_" prefix)
    $modules_conf = [],

    # Variables set in the main configuration file
    $var_log_root = '/var/log/lighttpd',
    $var_server_root = '/var/www',
    # Defaults to server_root + "/vhosts"
    $var_vhosts_dir = false,
    $var_cache_dir = '/var/cache/lighttpd',
    # Defaults to home_dir + "/sockets"
    $var_socket_dir = false,

    # Main non-module options
    $server_port = '80',
    $server_use_ipv6 = 'enable',
    # Defaults to bind to all
    $server_bind = false,
    $server_username = 'lighttpd',
    $server_groupname = 'lighttpd',
    # Defaults to server_root + "/lighttpd"
    $server_document_root = false,
    $server_tag = 'lighttpd',
    $server_network_backend = 'linux-sendfile',
    $server_max_fds = '2048',
    $server_max_connections = '1024',
    $server_max_keep_alive_idle = '5',
    $server_max_keep_alive_requests = '16',
    $server_max_request_size = '0',
    $server_max_read_idle = '60',
    $server_max_write_idle = '360',
    $server_kbytes_per_second = false,
    $connection_kbytes_per_second = false,
    $index_file_names = [ 'index.html' ],
    $url_access_deny = [ '~', '.inc' ],
    $static_file_exclude_extensions = [ '.php', '.pl', '.fcgi', '.scgi' ],
    $server_follow_symlink = 'enable',
    $server_force_lowercase_filenames = 'disable',

    # Module secific options
    # dirlisting (enabled by default)
    $dir_listing_activate = 'disable',
    $dir_listing_hide_dotfiles = 'disable',
    $dir_listing_exclude = [ '~$' ],
    $dir_listing_encoding = 'UTF-8',
    $dir_listing_external_css = false,
    $dir_listing_hide_header_file = 'disable',
    $dir_listing_show_header = 'disable',
    $dir_listing_hide_readme_file = 'disable',
    $dir_listing_show_readme = 'disable'
) {

    # Main package and service
    package { 'lighttpd': ensure => installed }
    service { 'lighttpd':
        ensure  => running,
        enable  => true,
        # Lighttpd refuses to start if its document_root doesn't exist...
        # hard to handle cleanly. The default "just works", though.
        #require => File[$server_document_root],
        restart => '/sbin/service lighttpd restart',
    }

    # Puppet auto-requires parent directories, so use that feature instead of
    # requiring the package for each configuration file.
    file { '/etc/lighttpd':
        ensure  => directory,
        require => Package['lighttpd'],
    }

    # Main configuration file
    file { '/etc/lighttpd/lighttpd.conf':
        content => template('lighttpd/lighttpd.conf.erb'),
        notify  => Service['lighttpd'],
    }
    # Modules configuration file
    file { '/etc/lighttpd/modules.conf':
        content => template('lighttpd/modules.conf.erb'),
        notify  => Service['lighttpd'],
    }

    # Per-module configuration file
    file { '/etc/lighttpd/conf.d/dirlisting.conf':
        content => template('lighttpd/conf.d/dirlisting.conf.erb'),
        notify  => Service['lighttpd'],
    }

    # "can't have more connections than fds/2" so we need to raise max_fds to
    # 2048 by default, this requires httpd_setrlimit with SELinux
    if $::selinux and $::selinux_enforced {
        selboolean { 'httpd_setrlimit':
            persistent => true,
            value      => 'on',
        }
    }

}

