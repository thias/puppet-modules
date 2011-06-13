# Apache httpd web server service base class.
# This class is not meant to be used on its own.
# It exists only because parametrized classes cannot be inherited reliably
# (as of 2.6.8), so we have the main apache-httpd definition wrapping around
# non-parametrized classes with inheritence.
#
class apache-httpd::service::base {

    # Main service, modified in inherited classes
    service { 'httpd':
        ensure    => running,
        enable    => true,
        restart   => '/sbin/service httpd reload',
        hasstatus => true,
        require   => Package['httpd'],
    }

}

