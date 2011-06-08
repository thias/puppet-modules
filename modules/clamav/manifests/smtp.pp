# ClamAV SMTP definition to enable clamsmtp, for use with MTAs.
#
# Sample Usage :
#    none
#
class clamav::smtp {

    include clamav

    # Main package and services
    package { [ "clamsmtp" ]: ensure => installed }
    service { [ "clamsmtpd", "clamsmtp-clamd" ]:
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

}

