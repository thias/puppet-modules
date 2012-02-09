# Nginx configuration file, installed from source or template.
#
# Sample Usage :
#     nginx::conf { 'example.conf':
#         source => 'puppet:///files/nginx/example.conf',
#     }
#
define nginx::conf (
    $content = undef,
    $source  = undef
) {
    file { "/etc/nginx/conf.d/${title}":
        content => $content,
        source  => $source,
        notify  => Service['nginx'],
        require => Package['nginx'],
    }
}

