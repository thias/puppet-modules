# The secret file must be manually generated and stored on the puppetmaster.
# To generate an OpenVPN secret file :
#     openvpn --genkey --secret example.key
# Usage :
#     openvpn::secret { 'example.key':
#         source => 'puppet:///files/openvpn/example.key',
#     }
#
define openvpn::secret (
    $dir = '/etc/openvpn',
    $source  = undef,
    $content = undef
) {

    file { "${dir}/${title}":
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        source  => $source,
        content => $content,
        # For the default parent directory
        require => Package['openvpn'],
    }

}

