# Local SELinux modules, created from avc denial messages to be allowed.
#
# You must copy the avc denial messages of what you want to allow to :
# files/messages.<selinux_module_name>
#
# The module names loaded are automatically prefixed with "local" in order to
# never conflict with modules from the currently loaded policy.
# You can get a list of existing loaded modules with : semodule -l
#
# Sample Usage :
#     selinux::audit2allow { 'mydaemon': }
#     selinux::audit2allow { 'myotherdaemon':
#         source => "puppet:///files/${::fqdn}/selinux-messages",
#     }
#
define selinux::audit2allow (
    $source = false
) {

    include selinux

    # Parent directory and directory
    realize File['/etc/selinux/local']
    file { "/etc/selinux/local/${title}": ensure => directory }

    # The deny messages we want to allow
    file { "/etc/selinux/local/${title}/messages":
        source => $source ? {
            false   => "puppet:///modules/selinux/messages.${title}",
            default => $source,
        },
    }

    # Reload the changes automatically
    exec { "audit2allow -M local${title} -i messages && semodule -i local${title}.pp":
        require     => Package['audit2allow'],
        path        => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        cwd         => "/etc/selinux/local/${title}",
        subscribe   => File["/etc/selinux/local/${title}/messages"],
        refreshonly => true,
    }

    # Clean up the old naming, without the "local" prefix
    file { [ "/etc/selinux/local/${title}/${title}.pp",
             "/etc/selinux/local/${title}/${title}.te" ]:
        ensure => absent,
    }

}

