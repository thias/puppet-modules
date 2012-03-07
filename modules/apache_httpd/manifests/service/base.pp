# Class: apache_httpd::service::base
#
# Apache httpd web server service base class.
# This class is not meant to be used on its own.
# It exists only because parametrized classes cannot be inherited reliably
# (as of 2.6.8), so we have the main apache_httpd definition wrapping around
# small non-parametrized classes with inheritence.
#
class apache_httpd::service::base {

    # Main service, modified in inherited classes
    service { 'httpd':
        ensure    => running,
        enable    => true,
        restart   => '/sbin/service httpd reload',
        hasstatus => true,
        require   => Package['httpd'],
    }

}

