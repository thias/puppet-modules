class apache-httpd::internal::ssl-php inherits apache-httpd::internal::ssl {

    # Main package and service changes
    package { "php": ensure => installed }
    Service["httpd"] {
        require   +> Package["php"],
        subscribe +> [
            File["/etc/php.ini"],
            Package["php"]
        ],
    }

}

