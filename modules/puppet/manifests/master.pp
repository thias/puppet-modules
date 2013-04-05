# Class: puppet::master
#
# Install and configure a puppet master.
#
# Sample Usage :
#   class { 'puppet::master':
#       runtype => 'service|passenger|none',
#   }
#
class puppet::master (
    $ensure         = 'present',
    $runtype        = 'service',
    $selinux        = $::selinux,
    # puppet.conf options
    $certname       = undef,
    $dns_alt_names  = undef,
    $reports        = undef,
    $reporturl      = undef,
    $storeconfigs   = undef,
    $storeconfigs_backend = undef,
    $dbadapter      = undef,
    $dbserver       = undef,
    $dbname         = undef,
    $dbuser         = undef,
    $dbpassword     = undef,
    $dbsocket       = undef,
    $extraopts      = {}
) {

    include puppet::common

    # Package + partial configuration file + concatenation exec
    if $ensure != 'absent' {

        package { 'puppet-server': ensure => installed }
        if $storeconfigs {
            package { 'rubygem-activerecord': ensure => installed }
        }

        file { '/etc/puppet/puppetmaster.conf':
            owner   => 'root',
            group   => 'puppet',
            mode    => '0640',
            content => template('puppet/puppetmaster.conf.erb'),
        }

        # This will only work once the puppetmaster fact is installed, it's
        # a chicken and egg problem, which we solve here
        if $::puppetmaster == 'true' {
            # Merge agent+master configs for the master
            File['/etc/puppet/puppetmaster.conf'] ~> Exec['catpuppetconf']
        }

    } else {

        file { [
            '/etc/puppet/puppetmaster.conf',
            '/etc/puppet/puppetagent.conf',
        ]:
            ensure => absent,
        }

    }

    # Main puppet master process, with multiple ways of running it
    case $runtype {
        'service': {
            if $::puppetmaster == 'true' {
                service { 'puppetmaster':
                    enable    => true,
                    ensure    => running,
                    hasstatus => true,
                    subscribe => Exec['catpuppetconf'],
                }
            }
            if $selinux and $::selinux_enforced {
                selinux::audit2allow { 'puppetservice':
                    source => 'puppet:///modules/puppet/messages.puppetservice',
                }
            }
        }
        'passenger': {
            $https_certname = $certname ? {
                undef   => $::fqdn,
                default => $certname,
            }
            package { 'mod_passenger': ensure => installed }
            file { '/etc/httpd/conf.d/puppet.conf':
                owner   => 'root',
                group   => 'root',
                content => template('puppet/httpd-puppet.conf.erb'),
                notify  => Service['httpd'],
            }
            apache_httpd { 'worker':
                listen  => '8140',
                ssl     => true,
                modules => [
                    'auth_basic',
                    'authz_host',
                    'headers',
                    'mime',
                    'negotiation',
                    'dir',
                    'alias',
                    'rewrite',
                ],
                user    => 'puppet',
                group   => 'puppet',
                welcome => false,
            }
            file { '/etc/puppet/rack':
                owner  => 'root',
                group  => 'root',
                ensure => directory,
            }
            file { '/etc/puppet/rack/public':
                owner  => 'puppet',
                group  => 'puppet',
                ensure => directory,
            }
            file { '/etc/puppet/rack/config.ru':
                owner  => 'puppet',
                group  => 'puppet',
                mode   => '0644',
                source => 'puppet:///modules/puppet/config.ru',
            }
            if $selinux and $::selinux_enforced {
                selinux::audit2allow { 'puppetpassenger':
                    source => 'puppet:///modules/puppet/messages.puppetpassenger',
                }
            }
        }
        'none': {
        }
    }

}

