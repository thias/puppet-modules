# OpenVPN configuration from source or template.
# FIXME : Implement auto restart of the configured link after changes.
#
define openvpn::conf (
    $dir = '/etc/openvpn',
    $source = undef,
    $content = undef
) {

    include openvpn

    file { "${dir}/${title}.conf":
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        source  => $source,
        content => $content,
        # For the default parent directory
        require => Package['openvpn'],
    }
    # start
    exec { "openvpn-start-${title}":
        command => "/usr/sbin/openvpn --daemon --writepid /var/run/openvpn/${title}.pid --config ${title}.conf --cd ${dir}",
        cwd     => $dir,
        require => File["${dir}/${title}.conf"],
        creates => "/var/run/openvpn/${title}.pid",
    }
    # FIXME : stop/restart
    exec { "openvpn-stop-${title}":
        command => "kill `cat /var/run/openvpn/${title}.pid`",
        path    => [ '/bin', '/usr/bin' ],
        refreshonly => true, 
    }

}

