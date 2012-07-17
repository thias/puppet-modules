# Class: nagios::params
#
# Parameters for and from the nagios module.
#
# Parameters :
#  none
#
# Sample Usage :
#  include nagios::params
#
class nagios::params {
    $libdir = $::architecture ? {
        'x86_64' => 'lib64',
        'amd64'  => 'lib64',
         default => 'lib',
    }
    # The easy bunch
    $nagios_service = 'nagios'
    $nagios_user    = 'nagios'
    # nrpe
    $nrpe_service   = 'nrpe'
    $nrpe_cfg_file  = '/etc/nagios/nrpe.cfg'
    case $::operatingsystem {
        'Gentoo': {
            $nrpe_package       = [ 'net-analyzer/nagios-nrpe' ]
            $nrpe_package_alias = 'nrpe'
            $nrpe_user          = 'nagios'
            $nrpe_group         = 'nagios'
            $nrpe_pid_file      = '/var/run/nrpe/nrpe.pid'
            $nrpe_cfg_dir       = '/etc/nagios/nrpe.d'
        }
        'Fedora': {
            $nrpe_package       = [ 'nrpe', 'nagios-plugins' ]
            $nrpe_user          = 'nrpe'
            $nrpe_group         = 'nrpe'
            $nrpe_pid_file      = '/var/run/nrpe.pid'
            $nrpe_cfg_dir       = '/etc/nrpe.d'
        }
        default: {
            $nrpe_package       = [ 'nrpe', 'nagios-plugins' ]
            $nrpe_user          = 'nrpe'
            $nrpe_group         = 'nrpe'
            $nrpe_pid_file      = '/var/run/nrpe.pid'
            $nrpe_cfg_dir       = '/etc/nagios/nrpe.d'
        }
    }
    # Optional plugin packages, to be realized by tag where needed
    # Note: We use tag, because we can't use alias for 2 reasons :
    # * http://projects.puppetlabs.com/issues/4459
    # * The value of $alias can't be the same as $name
    $nagios_plugins_packages = [
        'nagios-plugins-disk',
        'nagios-plugins-file_age',
        'nagios-plugins-ide_smart',
        'nagios-plugins-ifstatus',
        'nagios-plugins-linux_raid',
        'nagios-plugins-load',
        'nagios-plugins-log',
        'nagios-plugins-mailq',
        'nagios-plugins-mysql',
        'nagios-plugins-mysql_health',
        'nagios-plugins-ntp',
        'nagios-plugins-oracle_health',
        'nagios-plugins-perl',
        'nagios-plugins-pgsql',
        'nagios-plugins-procs',
        'nagios-plugins-sensors',
        'nagios-plugins-swap',
        'nagios-plugins-users',
    ]
    case $operatingsystem {
        'Fedora': {
            $plugin_dir = "/usr/${libdir}/nagios/plugins"
            @package { $nagios_plugins_packages:
                tag    => $name,
                ensure => installed,
            }
        }
        'Gentoo': {
            $plugin_dir = "/usr/${libdir}/nagios/plugins"
            # No package splitting in Gentoo
            @package { 'net-analyzer/nagios-plugins':
                tag    => $nagios_plugins_packages,
                ensure => installed,
            }
        }
        default: {
            $plugin_dir = '/usr/libexec/nagios/plugins'
            @package { $nagios_plugins_packages:
                tag    => $name,
                ensure => installed,
            }
        }
    }

}

