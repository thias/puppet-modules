# Very simple class to install gitweb.
#
# Sample Usage :
#     include git::gitweb
# 
class git::gitweb (
    $confowner   = 'root',
    $confgroup   = 'root',
    $confmode    = '0644',
    $confcontent = undef,
    $confsource  = undef,
    $selinux     = true
) {

    package { 'gitweb': ensure => installed }

    # Main configuration file, very specific to each environment, so don't
    # even try to provide a default one.
    file { '/etc/gitweb.conf':
        owner   => $confowner,
        group   => $confgroup,
        mode    => $confmode,
        content => $confcontent,
        source  => $confsource,
        require => Package['gitweb'],
    }

    # With selinux, gitweb gets denied access to gitosis/gitolite files
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'gitweb':
            source => 'puppet:///modules/git/messages.gitweb',
        }
    }

}

