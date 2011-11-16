# Enable and disable already defined xinetd services.
#
# Sample Usage :
# * Enable rsyncd :
#    xinetd::service { "rsync": }
# * Disable rsyncd :
#    xinetd::service { "rsync": enable => false }
#
define xinetd::service ( $enable = true ) {

    include xinetd

    service { $title:
        enable => $enable,
    }

}

