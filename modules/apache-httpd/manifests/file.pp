# Apache httpd server configuration file definition.
#
# Sample Usage :
#     apache-httpd::file { "www.example.com.conf":
#         source => "puppet:///files/apache-httpd/www.example.com.conf",
#     }
#
define apache-httpd::file (
    $confd   = "/etc/httpd/conf.d",
    $owner   = "root",
    $group   = "root",
    $mode    = 0644,
    $source  = undef,
    $content = undef,
    $ensure  = undef
) {

    file { "${confd}/${title}":
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        source  => $source,
        content => $content,
        ensure  => $ensure,
        notify  => Service["httpd"],
    }

}

