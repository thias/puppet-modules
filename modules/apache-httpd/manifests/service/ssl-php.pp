class apache-httpd::service::ssl-php inherits apache-httpd::service::ssl {

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

