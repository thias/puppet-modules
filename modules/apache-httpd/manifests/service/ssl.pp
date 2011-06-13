class apache-httpd::service::ssl inherits apache-httpd::service::base {

    # Main package and service changes
    package { 'mod_ssl': ensure => installed }
    Service['httpd'] {
        require   +> Package['mod_ssl'],
        subscribe +> Package['mod_ssl'],
    }

    # We disable everything in the file except loading the module
    # To listen on 443, the directive is required in an apache-httpd::file
    apache-httpd::file { 'ssl.conf':
        content => template('apache-httpd/conf.d/ssl.conf'),
    }

}

