# Configure an OCO check. Currently only http is supported.
# Automatically includes the daemon class.
#
# Sample Usage :
#    ovh::oco::check { "http":
#        freq      => "300sec",
#        http_path => "/my-health-check.php",
#    }
#
define ovh::oco::check (
    # Must be 60sec, 120sec or 300sec
    $freq      = "60sec",
    # Most of there are specific to one possible check
    $http_host = "127.0.0.1",
    $http_path = "/",
    $ensure    = "present"
) {
    include ovh::oco::daemon
    file { "/usr/local/oco/bin/${freq}/${title}":
        require => Package["oco"],
        mode    => 0755,
        content => template("ovh/oco/${title}.erb"),
        ensure  => $ensure,
    }
}

