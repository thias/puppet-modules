# Configure the git user's home for repository management using gitolite.
#
# Usage :
#     class git::gitolite {
#         admin_sshkey     => 'AAAAHsKhmP44J0....j2H6pC8dU=',
#         admin_sshkeytype => 'rsa',
#     }
#
class git::gitolite (
    $admin_sshkey,
    $admin_sshkeytype,
    $gituser  = 'git',
    $gitgroup = 'git',
    $githome  = '/srv/git'
) {

    package { 'gitolite': ensure => installed }

    # The "gitolite" user is created by the package, others aren't
    $requireuser = $gituser ? {
        'gitolite' => [],
         default   => User[$gituser],
    }

    exec { "gl-setup ${githome}/admin.pub":
        user        => $gituser,
        group       => $gitgroup,
        path        => [ '/bin', '/usr/bin' ],
        environment => [ "HOME=${githome}" ],
        creates     => "${githome}/.gitolite.rc",
        require     => [
            Package['gitolite'],
            File["${githome}/admin.pub"],
            $requireuser,
        ],
    }

    file { "${githome}/admin.pub":
        content => "ssh-${admin_sshkeytype} ${admin_sshkey} admin\n",
        owner   => $gituser,
        group   => $gitgroup,
        mode    => '0600',
    }

}

