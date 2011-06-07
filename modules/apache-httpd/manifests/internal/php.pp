class apache-httpd::internal::php inherits apache-httpd::internal::base {

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

