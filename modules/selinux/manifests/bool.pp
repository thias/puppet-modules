# Set selinux booleans to "on" or "off".
# To get a list of all available booleans on a system, run : getsebool -a
#
# Sample Usage :
#    selinux::bool { [ "httpd_disable_trans", "use_nfs_home_dirs" ]:
#        val => "on",
#    }
#
define selinux::bool ( $val ) {

    include selinux

    $opposite = $val ? {
        'on'  => "off",
        'off' => "on",
    }

    # Set the selinux boolean if it's currently the opposite
    exec { "setsebool -P ${title} ${val}":
        onlyif => "getsebool ${title} | egrep ${opposite}\$",
        path   => [ "/usr/sbin", "/bin" ],
    }

}

