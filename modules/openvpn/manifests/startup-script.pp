# Class: openvpn::startup-script
#
# Example Usage:
#  $tapdev = 'tap1'
#  $tapbridge = 'br1'
#  class { 'openvpn::startup-script':
#      content => template('openvpn/openvpn-startup.erb'),
#  }
#
class openvpn::startup-script (
    $dir = '/etc/openvpn',
    $source  = undef,
    $content = undef
) {

    file { "${dir}/openvpn-startup":
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        source  => $source,
        content => $content,
        # For the default parent directory
        require => Package['openvpn'],
        before  => Service['openvpn'],
    }

}

