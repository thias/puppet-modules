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
    $admin_sshkeytype
) {

    package { 'gitosis': ensure => installed }
    
    exec { "echo ssh-${admin_sshkeytype} ${admin_sshkey} ${admin_username} | gitosis-init":
        user        => 'git',
        group       => 'git',
        path        => [ '/bin', '/usr/bin' ],
        environment => [ 'HOME=/srv/git' ],
        creates     => '/srv/git/.gitosis.conf',
        require     => [
            User['git'],
            Package['gitosis'],
        ],
    }

}

