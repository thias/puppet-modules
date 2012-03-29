# Class: php::params
#
# Parameters for and from the PHP module.
#
# Parameters : 
#  none
#
# Sample Usage :
#  include php::params
#
class php::params {

    $php_version = '5.3'

    # packages
    case $::operatingsystem {
        'Gentoo': { 
            @package { 'dev-lang/php': ensure => installed }
            $package_cli = 'dev-lang/php'
            $package_fpm = 'dev-lang/php'
        }
        /(RedHat|CentOS)/: {
            @package { 'php-cli': ensure => installed }
            @package { 'php-fpm': ensure => installed }
            $package_cli = 'php-cli'
            $package_fpm = 'php-fpm'
        }
    }

    # fpm
    case $::operatingsystem {
        'Gentoo': {
            $fpm_service = 'php-fpm'
            $fpm_conf = "/etc/php/fpm-php${php_version}/php-fpm.conf"
            $fpm_confd = "/etc/php/fpm-php${php_version}/php-fpm.d"
            $fpm_pid = false
            $fpm_error_log = '/var/log/php-fpm.log'
        }
        default: {
            $fpm_service = 'php-fpm'
            $fpm_conf = '/etc/php-fpm.conf'
            $fpm_confd = '/etc/php-fpm.d'
            $fpm_pid = '/var/run/php-fpm/php-fpm.pid'
            $fpm_error_log = '/var/log/php-fpm/error.log'
        }
    }

}

