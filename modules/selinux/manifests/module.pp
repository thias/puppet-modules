# Local SELinux modules, created from avc denial messages to be allowed.
#
# You must copy the avc denial messages of what you want to allow to :
# files/messages.<selinux_module_name>
#
# Beware of not using an existing module name or it will conflict. You can get
# a list of existing loaded modules with : semodule -l
#
# Sample Usage :
#    selinux::module { "mydaemon": }
#
define selinux::module () {

    include selinux

    # Parent directory and directory
    file { "/etc/selinux/local": ensure => directory }
    file { "/etc/selinux/local/${title}": ensure => directory }

    # The deny messages we want to allow
    file { "/etc/selinux/local/${title}/messages":
        source => "puppet:///modules/selinux/messages.${title}",
    }

    # Reload the change automatically
    exec { "audit2allow -M ${title} -i messages; semodule -i ${title}.pp":
        require   => Package["audit2allow"],
        path      => [ "/bin", "/usr/bin", "/sbin", "/usr/sbin" ],
        cwd       => "/etc/selinux/local/${title}",
        subscribe => File["/etc/selinux/local/${title}/messages"],
        creates   => "/etc/selinux/local/${title}/${title}.pp",
    }

}

