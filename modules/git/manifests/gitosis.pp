# Configure the git user's home for repository management using gitosis.
#
# Usage :
#     class git::gitosis {
#         admin_username   => 'jdoe',
#         admin_sshkey     => 'AAAAHsKhmP44J0....j2H6pC8dU=',
#         admin_sshkeytype => 'rsa',
#     }
#
class git::gitosis (
    $admin_username,
    $admin_sshkey,
    $admin_sshkeytype,
    $gituser  = 'git',
    $gitgroup = 'git',
    $githome  = '/srv/git'
) {

    package { 'gitosis': ensure => installed }
    
    # The "gitosis" user is created by the package, others aren't
    $requireuser = $gituser ? {
        'gitosis' => [],
         default   => User[$gituser],
    }

    exec { "echo ssh-${admin_sshkeytype} ${admin_sshkey} ${admin_username} | gitosis-init":
        user        => $gituser,
        group       => $gitgroup,
        path        => [ '/bin', '/usr/bin' ],
        environment => [ "HOME=${githome}" ],
        creates     => "${githome}/.gitosis.conf",
        require     => [
            Package['gitosis'],
            $requireuser,
        ],
    }

}

