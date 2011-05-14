# Simple xinetd class

class xinetd {

    package { "xinetd": ensure => installed }

    service { "xinetd":
        require   => Package["xinetd"],
        enable    => true,
        ensure    => running,
        restart   => "/sbin/service xinetd reload",
        # on RHEL5 "xinetd is stopped" has an exit status of 0...
        #hasstatus => true,
    }

    # xinetd::service for activating xinetd-based services
    define service () {
        include xinetd
        # Because the service is a sub-xinetd service and not standalone
        exec { "chkconfig ${title} on":
            notify => Service["xinetd"],
            path   => [ "/sbin", "/bin" ],
            onlyif => "chkconfig --list ${title} | grep -q off",
        }
    }

    # xinetd::serviceconf for full configuration of xinetd-based services
    define serviceconf (
        $ensure         = "present",
        # $id and $type are reserved puppet variables it seems...
        $service_id     = false,
        $service_type   = false,
        $flags          = false,
        $disable        = "no",
        $socket_type    = "stream",
        $protocol       = "tcp",
        $wait           = "no",
        $user           = "root",
        $group          = false,
        $instances      = false,
        $nice           = false,
        $server,
        $server_args    = false,
        $only_from      = false,
        $no_access      = false,
        $access_times   = false,
        $log_type       = false,
        $log_on_success = false,
        $log_on_failure = false,
        $rpc_version    = false,
        $rpc_number     = false,
        $env            = false,
        $passenv        = false,
        $port           = false,
        $redirect       = false,
        $bind           = false,
        $banner         = false,
        $banner_success = false,
        $banner_fail    = false,
        $per_source     = false,
        $cps            = false,
        $max_load       = false,
        $groups         = false,
        $mdns           = false,
        $umask          = false,
        $rlimit_as      = false,
        $rlimit_files   = false,
        $rlimit_cpu     = false,
        $rlimit_data    = false,
        $rlimit_rss     = false,
        $rlimit_stack   = false,
        $deny_time      = false
    ) {
        $service_name = $title
        if $ensure == "absent" {
            file { "/etc/xinetd.d/${service_name}":
                ensure => absent,
            }
            # We don't want to make xinetd mandatory for absent
            exec { "/sbin/service xinetd reload":
                subscribe   => File["/etc/xinetd.d/${service_name}"],
                refreshonly => true,
            }
        } else {
            include xinetd
            file { "/etc/xinetd.d/${service_name}":
                content => template("xinetd/xinetd.d-service.erb"),
                notify  => Service["xinetd"],
            }
        }
    }

}

