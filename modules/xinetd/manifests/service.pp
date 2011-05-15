# Enable and disable already defined xinetd services.
#
# Sample Usage :
# * Enable rsyncd :
#    xinetd::service { "rsync": }
# * Disable rsyncd :
#    xinetd::service { "rsync": disable => "yes" }
#
define xinetd::service ( $disable = "no" ) {

    include xinetd

    if $disable == "yes" {

        # Because the service is a sub-xinetd service and not standalone
        exec { "chkconfig ${title} off":
            notify => Service["xinetd"],
            path   => [ "/sbin", "/bin" ],
            onlyif => "chkconfig --list ${title} | egrep -q 'on$'",
        }

    } else {

        # Because the service is a sub-xinetd service and not standalone
        exec { "chkconfig ${title} on":
            notify => Service["xinetd"],
            path   => [ "/sbin", "/bin" ],
            onlyif => "chkconfig --list ${title} | egrep -q 'off$'",
        }

    }

}

