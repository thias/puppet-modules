# Define: nginx::file
#
# Manage NGINX configuration file snippets, installed from source or template.
# The main service is automatically notified when files are added, removed or
# modified.
#
# Parameters:
#  $content:
#    Content for the file, typically from a template. Default: none
#  $source:
#    Source for the file. Mutually exclusive with $content. Default: none
#
# Sample Usage :
#  nginx::file { 'example1.conf':
#      source => 'puppet:///files/nginx/example1.conf',
#  }
#  nginx::file { 'example2.conf':
#      content => template('mymodule/example2.conf.erb'),
#  }
#
define nginx::file (
    $content = undef,
    $source  = undef
) {
    include nginx::params
    file { "${nginx::params::confdir}/conf.d/${title}":
        content => $content,
        source  => $source,
        notify  => Service['nginx'],
        require => Package['nginx'],
    }
}

