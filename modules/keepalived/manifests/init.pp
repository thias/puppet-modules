# Class: keepalived
#
# Keepalived.
#
# Parameters:
#  $content:
#    File content for keepalived.conf. Default: none
#  $source:
#    File source for keepalived.conf. Default: none
#  $options:
#    Command-line options to keepalived. Default: -D
#
# Sample Usage :
#  class { 'keepalived':
#      source  => 'puppet:///mymodule/keepalived.conf',
#      options => '-D --vrrp',
#  }
#
class keepalived (
    $content    = undef,
    $source     = undef,
    $options    = '-D'
) {

    package { 'keepalived': ensure => installed }

    service { 'keepalived':
        enable    => true,
        ensure    => running,
        # "service keepalived status" always returns 0 even when stopped
        #hasstatus => true,
        require   => Package['keepalived'],
    }

    # Optionally managed main configuration file
    if $content or $source {
        file { '/etc/keepalived/keepalived.conf':
            content => $content,
            source  => $source,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            notify  => Service['keepalived'],
            require => Package['keepalived'],
        }
    }

    # Configuration for VRRP/LVS disabling
    file { '/etc/sysconfig/keepalived':
        content => template('keepalived/sysconfig.erb'),
        notify  => Service['keepalived'],
        require => Package['keepalived'],
    }

}

