# Define: ovh::oco::check
#
# Configure an OvhCheckOut check. Currently only http is supported.
# Automatically includes the daemon class.
#
# Parameters:
#  $freq:
#    The check execution frequency. Must be '60sec', '120sec' or '300sec'.
#    Defaults to '60sec'.
#  $http_host:
#    The IP address or host name for the check of 'http' type. Defaults to
#    '127.0.0.1'.
#  $http_path:
#    The URL path for the check of type 'http'. Defaults to '/'.
#  $ensure:
#    Whether the check should be 'present' or 'absent'. Defaults to 'present'.
#
# Sample Usage :
#  ovh::oco::check { 'http':
#      freq      => '300sec',
#      http_path => '/my-health-check.php',
#  }
#
define ovh::oco::check (
    # Must be 60sec, 120sec or 300sec
    $freq      = '60sec',
    # Most of there are specific to one possible check
    $http_host = '127.0.0.1',
    $http_path = '/',
    $ensure    = 'present'
) {
    include ovh::oco::daemon
    file { "/usr/local/oco/bin/${freq}/${title}":
        ensure  => $ensure,
        require => Package['oco'],
        mode    => '0755',
        content => template("ovh/oco/${title}.erb"),
    }
}

