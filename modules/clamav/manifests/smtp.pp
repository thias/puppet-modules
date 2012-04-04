# Class: clamav::smtp
#
# ClamAV SMTP class, to use an antivirus service with MTAs. The default
# configuration will have the service listen on a UNIX socket and re-send
# to localhost:10026.
#
# Sample Usage :
#  include clamav::smtp
#
class clamav::smtp {

    include clamav

    # Main package and services
    if $::operatingsystemrelease < 6 {
        $clamd_service = 'clamd.smtp'
    } else {
        $clamd_service = 'clamsmtp-clamd'
    }
    package { [ 'clamsmtp' ]: ensure => installed }
    service { [ 'clamsmtpd', $clamd_service ]:
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['clamsmtp'],
    }

}

