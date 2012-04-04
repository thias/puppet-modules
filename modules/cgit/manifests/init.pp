# Class: cgit
#
# Sample Usage :
#  apache_httpd { 'worker':
#      modules   => [ 'mime', 'setenvif', 'alias', 'proxy', 'cgi' ],
#      keepalive => 'On',
#      user      => 'git',
#      group     => 'git',
#  }
#  class { 'cgit':
#      httpd_path      => '/git',
#      httpd_path_data => '/git-data',
#      clone_prefix    => 'git://git.marmotte.net',
#      css             => '/git-data/cgit.css',
#      logo            => '/git-data/pink-spaceinvader.png',
#      logo_link       => 'http://thias.marmotte.net/',
#      favicon         => 'http://thias.marmotte.net/favicon.ico',
#      snapshots       => 'tar.gz',
#      max_stats       => false,
#      root_title      => 'Git repositories on marmotte.net',
#      root_desc       => 'commit, push... et alors, la marmotte...',
#      repos           => {
#          'puppet-modules' => {
#              'path'  => '/srv/git/repositories/puppet-modules.git',
#              'desc'  => 'Custom Puppet Modules',
#              'owner' => 'Matthias Saou',
#          },
#      },
#  }
#  # Default is apache:root
#  file { '/var/cache/cgit':
#      ensure => directory,
#      owner  => 'git',
#  }
#
class cgit (
    $httpd_conf             = true,
    $httpd_path             = '/cgit',
    $httpd_path_data        = '/cgit-data',
    # allow using an entirely custom cgitrc file
    $cgitrc_source          = undef,
    $cgitrc_content         = undef,
    # cgitrc options when using the provided template
    $cache_size             = '1000',
    $clone_prefix           = false,
    $css                    = '/cgit-data/cgit.css',
    $enable_index_links     = '1',
    $enable_commit_graph    = '1',
    $enable_log_filecount   = '1',
    $enable_log_linecount   = '1',
    $favicon                = false,
    $logo                   = '/cgit-data/cgit.png',
    $logo_link              = false,
    $max_stats              = 'quarter',
    $root_title             = false,
    $root_desc              = false,
    $root_readme            = false,
    $snapshots              = false,
    $mimetypes              = [],
    $source_filter          = false,
    $repos                  = {},
    $scan_path              = false,
    $remove_suffix          = false
) {

    # Main package
    package { 'cgit':
        ensure  => installed,
    }

    # Main configuration file
    if $cgitrc_source {
        $content = undef
    } elsif $cgitrc_content {
        $content = $cgitrc_content
    } else {
        $content = template('cgit/cgitrc.erb')
    }
    file { '/etc/cgitrc':
        content => $content,
        source  => $cgitrc_source,
    }

    if $httpd_conf {
        # Apache httpd configuration snippet
        file { '/etc/httpd/conf.d/cgit.conf':
            content => template('cgit/httpd-cgit.conf.erb'),
            notify  => Service['httpd'],
        }
    }

}

