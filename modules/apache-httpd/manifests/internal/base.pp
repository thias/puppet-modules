# Apache httpd web server base class.
# This class is not meant to be used on its own, as it expects many variables
# to be available from the previous scope.
# It exists only because parametrized classes cannot be inherited reliably
# (as of 2.6.8), so we have the main apache-httpd definition wrapping around
# non-parametrized classes with inheritence.
#
class apache-httpd::internal::base {

    # Main package and service
    package { "httpd": ensure => installed }
    service { "httpd":
        require   => Package["httpd"],
        enable    => true,
        ensure    => running,
        restart   => "/sbin/service httpd reload",
        hasstatus => true,
    }

    # Our own pre-configured file (disable nearly everything)
    file { "/etc/httpd/conf/httpd.conf":
        require => Package["httpd"],
        content => template("apache-httpd/conf/httpd.conf.erb"),
        notify  => Service["httpd"],
    }

    # On RHEL5, this gets in the way... it should be configured from elsewhere
    if ( $operatingsystem == "RedHat" ) and ( $operatingsystemrelease < 6 ) {
        # We can't "ensure => absent" or it would reappear with updates
        apache-httpd::file { "proxy_ajp.conf":
            source => "puppet:///modules/apache-httpd/proxy_ajp.conf",
        }
    } else {
        # Just in case we have updated from RHEL5
        apache-httpd::file { "proxy_ajp.conf":
            ensure  => absent,
        }
    }

    # Install extra file to disable TRACE and TRACK methods
    apache-httpd::file { "trace.inc":
        source => "puppet:///modules/apache-httpd/trace.inc",
    }

    # Change the original welcome condition, since our default has the index
    # return 404 instead of 403.
    if $welcome {
        apache-httpd::file { "welcome.conf":
            source => "puppet:///modules/apache-httpd/welcome.conf",
        }
    } else {
        apache-httpd::file { "welcome.conf":
            ensure => absent,
        }
    }

    # Tweak the sysconfig file
    file { "/etc/sysconfig/httpd":
        require => Package["httpd"],
        content => template("apache-httpd/etc/sysconfig.erb"),
        notify  => Service["httpd"],
    }

    # Install the custom logrotate file
    file { "/etc/logrotate.d/httpd":
        require => Package["httpd"],
        content => template("apache-httpd/etc/logrotate.erb"),
    }

}

