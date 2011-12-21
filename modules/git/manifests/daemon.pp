class git::daemon (
    $base_path    = '/srv/git/repositories',
    $server       = '/usr/libexec/git-core/git-daemon',
    $disable      = 'no',
    $user         = 'nobody',
    $verbose      = true,
    $export_all   = false,
    $strict_paths = false,
    $user_path    = 'public_git',
    $directories  = ''
) {

    $verbose_option = $verbose ? {
        true    => ' --verbose',
        default => '',
    }

    $export_all_option = $export_all ? {
        true    => ' --export-all',
        default => '',
    }

    $strict_paths_option = $strict_paths ? {
        true    => ' --strict-paths',
        default => '',
    }

    package { 'git-daemon': ensure => installed }
    xinetd::service { 'git':
        require => Package['git-daemon'],
    }

    file { '/etc/xinetd.d/git':
        content => template('git/git-xinetd.erb'),
        notify  => Service['xinetd'],
        require => [
            Package['git-daemon'],
            Xinetd::Service['git'],
        ],
    }

}

