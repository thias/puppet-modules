# Pure-FTPd FTP server class.
#
# The defaults are as close as possible to the original Fedora/EPEL defaults.
#
class pure-ftpd (
    $chrooteveryone             = 'yes',
    $trustedgid                 = false,
    $brokenclientscompatibility = 'no',
    $maxclientsnumber           = '50',
    # This is a puppet low-level variable, we always want the daemon anyway
    #daemonize                  = 'yes',
    $maxclientsperip            = '8',
    $verboselog                 = 'no',
    $displaydotfiles            = 'yes',
    $anonymousonly              = 'no',
    $noanonymous                = 'no',
    $syslogfacility             = 'ftp',
    $fortunesfile               = false,
    $dontresolve                = 'yes',
    $maxidletime                = '15',
    $puredb                     = false,
    $extauth                    = false,
    $pamauthentication          = 'yes',
    $limitrecursion             = '10000 8',
    $anonymouscancreatedirs     = 'no',
    $maxload                    = '4',
    $antiwarez                  = 'yes',
    $umask                      = '133:022',
    $minuid                     = '500',
    $useftpusers                = 'no',
    $allowuserfxp               = 'no',
    $allowanonymousfxp          = 'no',
    $altlog                     = 'clf:/var/log/pureftpd.log',
    $nochmod                    = 'no',
    $createhomedir              = 'no',
    $maxdiskusage               = '99',
    $customerproof              = 'yes',
    # PEM used is hardcoded to /etc/pki/pure-ftpd/pure-ftpd.pem
    $tls                        = false,
    $ipv4only                   = 'no',
    $ipv6only                   = 'no'
) {

    # Chicken and egg! Initial conf requires this, but package provides it
    file { '/etc/pure-ftpd':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    # Main package and service it provides
    package { 'pure-ftpd': ensure => installed }
    service { 'pure-ftpd':
        require   => [ File['/etc/pure-ftpd/pure-ftpd.conf'], Package['pure-ftpd'] ],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

    # Main configuration file
    file { '/etc/pure-ftpd/pure-ftpd.conf':
        require => File['/etc/pure-ftpd'],
        content => template('pure-ftpd/pure-ftpd.conf.erb'),
        notify  => Service['pure-ftpd'],
    }

    # PureDB file
    if $puredb {
        # Get pureftpd.passwd from pureftpd.pdb
        $purepasswd = regsubst($puredb, '^(.+)\.pdb$', '\1.passwd')
        file { '/etc/profile.d/pureftpd.sh':
            content => "# PureDB user database location (see README.Virtual-Users)

export PURE_PASSWDFILE=${purepasswd}
export PURE_DBFILE=${puredb}

",
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

}

