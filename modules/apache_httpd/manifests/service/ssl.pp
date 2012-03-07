# Class: apache_httpd::service::ssl
#
# Apache httpd web server service ssl class, inherited from the base class.
#
# We add the mod_ssl package with a stipped-down configuration. This class is
# not meant to be included on its own, but from the main class when $ssl is
# true.
#
class apache_httpd::service::ssl inherits apache_httpd::service::base {

    # Main package and service changes
    package { 'mod_ssl': ensure => installed }
    Service['httpd'] {
        require   +> Package['mod_ssl'],
        subscribe +> Package['mod_ssl'],
    }

    # We disable everything in the file except loading the module
    # To listen on 443, the directive is required in an apache_httpd::file
    apache_httpd::file { 'ssl.conf':
        require => Package['mod_ssl'],
        content => template('apache_httpd/conf.d/ssl.conf'),
    }

}

