service { 'httpd': }
# Real world example as smoke test
class { 'cgit':
    httpd_path      => '/git',
    httpd_path_data => '/git-data',
    cache_size      => '0',
    clone_prefix    => 'git://git.marmotte.net',
    css             => '/git-data/cgit.css',
    logo            => '/git-data/pink-spaceinvader.png',
    logo_link       => 'http://thias.marmotte.net/',
    favicon         => 'http://thias.marmotte.net/wp-content/themes/thiasblog/images/favicon/marmotte.ico',
    snapshots       => 'tar.gz',
    max_stats       => false,
    root_title      => 'Git repositories on marmotte.net',
    root_desc       => 'commit, push... et alors, la marmotte...',
    repos           => {
        'puppet-modules' => {
            'path'  => '/srv/git/repositories/puppet-modules.git',
            'desc'  => 'Custom Puppet Modules',
            'owner' => 'Matthias Saou',
        },
        'rpms' => {
            'path'  => '/srv/git/repositories/rpms.git',
            'desc'  => 'Source to RPM Packages',
            'owner' => 'Matthias Saou',
        },
    },
}

