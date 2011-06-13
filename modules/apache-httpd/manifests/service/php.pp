class apache-httpd::service::php inherits apache-httpd::service::base {

    # Main package and service changes
    package { 'php': ensure => installed }
    Service['httpd'] {
        require   +> Package['php'],
        subscribe +> [
            File['/etc/php.ini'],
            Package['php']
        ],
    }

}

