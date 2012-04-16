# Requires puppet >= 2.6 because it uses "undef" default parameters.
# Sample Usage :
#
define postfix::dbfile (
    $postfixdir = "/etc/postfix",
    $owner      = "root",
    $group      = "root",
    $mode       = 0644,
    $content    = undef,
    $source     = undef,
    $ensure     = undef
) {

    file { "${postfixdir}/${title}":
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        content => $content,
        source  => $source,
        ensure  => $ensure,
        notify  => Service["postfix"],
    }

    exec { "/usr/sbin/postmap ${title}":
        cwd         => $postfixdir,
        subscribe   => File["${postfixdir}/${title}"],
        refreshonly => true,
    }

}

