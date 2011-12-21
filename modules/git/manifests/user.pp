# Git system user.
#
# Sample Usage :
#     include git::user
#
class git::user {

    user { 'git':
        comment    => 'GIT Version Control',
        ensure     => present,
        shell      => '/bin/bash',
        home       => '/srv/git',
        managehome => true,
    }

}

