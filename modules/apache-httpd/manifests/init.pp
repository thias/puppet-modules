# Apache httpd web server definition.
#
# The title must be "prefork" (RHEL default) or "worker". The defaults are
# as close as possible to the original RHEL defaults. The configuration files
# are based on RHEL6's httpd 2.2 files, but work fine with RHEL5's 2.0 httpd.
#
# Note that by default a minimal set of modules is enabled in order to have
# the original testing page work, but passing an array of module names as the
# "modules" parameter resets them to only the "log" module.
#
# Sample Usage :
# apache-httpd { "prefork":
#     modules => [ "mime" ],
# }
#
define apache-httpd (
    $ssl                    = false,
    $php                    = false,
    # Options for the sysconfig file
    $options                = false,
    $httpd_lang             = false,
    $pidfile                = false,
    # Options for httpd.conf
    # These aren't critical modules, but they are needed for welcome.conf
    $modules                = [
        "authz_host",
        "include",
        "mime",
        "negotiation",
        "alias",
    ],
    # The original default is "OS", but "Prod" makes more sense to hide version
    $servertokens           = "Prod",
    # timeout is a reserved puppet variable
    $timeout_seconds        = "60",
    $keepalive              = "Off",
    $maxkeepaliverequests   = "100",
    $keepalivetimeout       = "15",
    $startservers           = "4",
    $minspareservers        = "2",
    $maxspareservers        = "8",
    $serverlimit            = "256",
    $maxclients             = "256",
    $maxrequestsperchild    = "4000",
    $minsparethreads        = "25",
    $maxsparethreads        = "75",
    $threadsperchild        = "32",
    $listen                 = "80",
    $extendedstatus         = "Off",
    $user                   = "apache",
    $group                  = "apache",
    $serveradmin            = "root@localhost",
    $usecanonicalname       = "Off",
    $documentroot           = "/var/www/html",
    $serversignature        = "On",
    # Other
    $welcome                = true,
    $logrotate_files        = '/var/log/httpd/*log',
    $logrotate_freq         = "daily",
    $logrotate_opts         = [ "compress", "missingok", "notifempty", "sharedscripts" ]
) {

    # Since this is a definition, make the title somewhat meaningful
    $worker = $title ? {
        'worker'  => true,
        'prefork' => false,
    }

    # We use classes with inheritence in order to perform useful overrides
    # Use only if/else in order to be compatible with puppet 0.25
    if $ssl and $php {
        include apache-httpd::internal::ssl-php
    } else {
        if $ssl {
            include apache-httpd::internal::ssl
        } else {
            if $php {
                include apache-httpd::internal::php
            } else {
                include apache-httpd::internal::base
            }
        }
    }

}

