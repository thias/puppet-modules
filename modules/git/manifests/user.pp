# Git system user.
#
# Sample Usage :
#     include git::user
#
class git::user (
    $username   = 'git',
    $comment    = 'GIT Version Control',
    $ensure     = present,
    $shell      = '/bin/bash',
    $home       = '/srv/git',
    $managehome = true
) {

    user { $username:
        comment    => $comment,
        ensure     => $ensure,
        shell      => $shell,
        home       => $home,
        managehome => $managehome,
    }

}

