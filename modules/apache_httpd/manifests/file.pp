# Define: apache_httpd::file
#
# Apache httpd server configuration file definition. Any new, removed or
# changed files will automatically reload the httpd server.
# Note that for major changes, such as address binds, SSL certificate changes,
# etc. it might still be needed to force a full restart of the service.
#
# Parameters:
#  $source:
#    The puppet file type 'source' value where to take the configuration file
#    from. Mutually exclusive with $content. Default: none.
#  $content:
#    The puppet file type 'content' value for the configuration file's content.
#    Mutually exclusive with $source. Default: none.
#  $ensure:
#    Whether the file should be 'present' or 'absent'. Defaults to 'present'.
#
# Sample Usage :
#  apache_httpd::file { 'www.example.com.conf':
#      source => 'puppet:///files/apache_httpd/www.example.com.conf',
#  }
#  apache_httpd::file { 'foo.conf':
#      content => "LoadModule foo_module modules/foo.so\nFooDirective\n",
#  }
#  apache_httpd::file { 'mod_unwanted.conf':
#      ensure => absent,
#  }
#
define apache_httpd::file (
    $confd   = '/etc/httpd/conf.d',
    $owner   = 'root',
    $group   = 'root',
    $mode    = '0644',
    $source  = undef,
    $content = undef,
    $ensure  = undef
) {
    file { "${confd}/${title}":
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        source  => $source,
        content => $content,
        notify  => Service['httpd'],
        # For the default parent directory
        require => Package['httpd'],
    }
}

