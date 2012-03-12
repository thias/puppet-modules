# Simple puppetmaster class.
#
#     class { 'puppet::master':
#         runtype => 'service|passenger|none',
#     }
#
class puppet::master (
    $ensure         = 'present',
    $runtype        = 'service',
    $selinux        = true,
    # puppet.conf options
    $certname       = false,
    $dns_alt_names  = false,
    $reports        = false,
    $reporturl      = false,
    $storeconfigs   = false,
    $dbadapter      = 'mysql',
    $dbserver       = 'localhost',
    $dbname         = 'puppet',
    $dbuser         = 'puppet',
    $dbpassword     = 'puppet',
    $dbsocket       = '/var/lib/mysql/mysql.sock',
    $extraopts      = {}
) {

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
            exec { 'catpuppetconf':
                command     => '/bin/cat /etc/puppet/puppetagent.conf /etc/puppet/puppetmaster.conf > /etc/puppet/puppet.conf',
                refreshonly => true,
                subscribe   => [
                    File['/etc/puppet/puppetagent.conf'],
                    File['/etc/puppet/puppetmaster.conf'],
                ],
            }
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
        }
        'passenger': {
            $https_certname = $certname ? {
                false   => $::fqdn,
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

