# Simple puppet client class

class puppet::client (
    $service = true,
    $sysconfig = true,
    # Simple hourly cron job, only if the service is disabled
    $cron_enable = false,
    $cron_silent = false,
    # puppet.conf options
    $pluginsync = 'true',
    $report = false,
    $autonoop = false,
    $forcenoop = false,
    $master = false,
    # sysconfig / repuppet options
    $puppet_server = 'puppet',
    $puppet_port = '8140',
    $puppet_log = '/var/log/puppet/puppet.log',
    $puppet_extra_opts = '--waitforcert=500'
) {

    $puppetversion = $::puppetversion

    # Enable noop by default on all xen and physical hosts and puppetmasters
    # + a few exceptions of non-critical physical hosts
    if ( ( $virtual == 'xen0' or $virtual == 'physical' or $master == true ) and $autonoop == true ) or $forcenoop == true {
        $puppet_noop = true
    } else {
        $puppet_noop = false
    }

    # Configuration changes, make it easy to deploy new options
    # and change to mode 600 so that regular users can't easily find the server
    if $sysconfig {
        file { '/etc/sysconfig/puppet':
            owner   => 'root',
            group   => 'puppet',
            mode    => '0640',
            content => template('puppet/sysconfig-puppet.erb'),
        }
    }
    # Main configuration for the service. Always install, just in case the
    # service is run when it shouldn't have been (we respect noop here).
    file { '/etc/puppet/puppet.conf':
        group   => 'puppet',
        mode    => '0640',
        content => template('puppet/puppet.conf.erb'),
    }

    # Lock down puppet logs, to not give everyone read access to them
    file { '/var/log/puppet':
        ensure => directory,
        owner  => 'puppet',
        group  => 'puppet',
        mode   => '0750',
    }

    if $service {
        service { 'puppet':
            enable    => true,
            ensure    => running,
            hasstatus => true,
            # Make sure puppet reloads (HUP) after configuration changes...
            # Does not work, see http://projects.puppetlabs.com/issues/1273
            restart   => '/sbin/service puppet reload',
            subscribe => File['/etc/puppet/puppet.conf'],
        }
    } else {
        # Disable running puppet as a service when it takes so much memory
        service { 'puppet':
            enable    => false,
            hasstatus => true,
            ensure    => stopped,
        }
        if $cron_enable {
            if $puppet_noop { $cmd_noop = ' --noop' } else { $cmd_noop = '' }
            # We might not care about the output when we have a Dashboard
            if $cron_silent { $cmd_end = ' >/dev/null' } else { $cmd_end = '' }
            cron { 'puppet-client':
                command => "/usr/local/sbin/repuppet${cmd_noop}${cmd_end}",
                user    => 'root',
                minute  => fqdn_rand(60),
            }
        }
    }

    # Useful script to force a puppet run at any time
    file { '/usr/local/sbin/repuppet':
        mode    => '0750',
        content => template('puppet/repuppet.erb'),
    }

}

