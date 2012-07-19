# Class: moxi
#
# Moxi Server. Everything is kept in /opt/moxi as this is where the upstream
# rpm package puts everything. Arguably ugly indeed.
#
# Parameters:
#  $options:
#    Additional command-line moxi options. Default: none
#  $cluster_url:
#    Membase cluster URL. Mandatory.
#  $usr:
#    Optional Membase user. Default: no auth
#  $pwd:
#    Optional Membase password. Default: no auth
#  $port_listen:
#    Local port to listen on. Default: '11211'
#  $default_bucket_name:
#    Name of the default bucket. Default: 'default'
#  $downstream_max,
#  $downstream_conn_max,
#  $downstream_conn_queue_timeout,
#  $downstream_timeout,
#  $wait_queue_timeout,
#  $connect_max_errors,
#  $connect_retry_interval,
#  $connect_timeout,
#  $auth_timeout,
#  $cycle:
#    Other Moxi parameters. See documentation.
#
# Sample Usage :
#  include moxi
#
class moxi (
    # TODO Gentoo : $rpmbasename = 'moxi-server_x86_64_1.7.2',
    # init.d/moxi options - see moxi -h
    $options = '',
    # moxi-cluster.cfg options
    $cluster_url,
    # moxi.cfg options
    $usr = false,
    $pwd = false,
    $port_listen = '11211',
    $default_bucket_name = 'default',
    $downstream_max = '1024',
    $downstream_conn_max = '4',
    $downstream_conn_queue_timeout = '200',
    $downstream_timeout = '5000',
    $wait_queue_timeout = '200',
    $connect_max_errors = '5',
    $connect_retry_interval = '30000',
    $connect_timeout = '400',
    $auth_timeout = '100',
    $cycle = '200'
) {

    package { 'moxi-server': ensure => installed }

    # TODO Gentoo : /etc/init.d/moxi & /etc/conf.d/moxi

    # The main configuration files
    file { '/opt/moxi/etc/moxi.cfg':
        owner   => 'moxi',
        group   => 'moxi',
        content => template('moxi/moxi.cfg.erb'),
        require => Package['moxi-server'],
        notify  => Service['moxi-server'],
    }
    file { '/opt/moxi/etc/moxi-cluster.cfg':
        owner   => 'moxi',
        group   => 'moxi',
        content => template('moxi/moxi-cluster.cfg.erb'),
        require => Package['moxi-server'],
        notify  => Service['moxi-server'],
    }

    # We make the directory writeable by moxi so that we can dump pid, log,
    # sock... ugly, yeah.
    file { '/opt/moxi':
        owner   => 'moxi',
        group   => 'moxi',
        mode    => '0755',
        ensure  => directory,
        require => Package['moxi-server'],
    }
    file { '/etc/logrotate.d/moxi':
        content => template('moxi/logrotate.d/moxi.erb'),
    }

    # The rpm package's init script cannot add command-line options :-(
    if $::operatingsystem =~ /RedHat|CentOS|Fedora/ {
        file { '/etc/sysconfig/moxi-server':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => "OPTIONS=\"${options}\"\n",
        }
        file { '/opt/moxi/etc/moxi-init.d':
            owner  => 'bin',
            group  => 'bin',
            mode   => '0755',
            source => 'puppet:///modules/moxi/moxi-init.d',
            before => Service['moxi-server'],
        }
    }

    # The package should take care of the user, this will tweak if needed
    user { 'moxi':
        comment => 'Moxi system user',
        home    => '/opt/moxi',
        shell   => '/sbin/nologin',
        system  => true,
        require => Package['moxi-server'],
    }

    service { 'moxi-server':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['moxi-server'],
    }

    # With selinux, we need more tweaks
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'moxi':
            source => 'puppet:///modules/moxi/messages.moxi',
        }
    }

}

