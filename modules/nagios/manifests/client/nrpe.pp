# Definition to install client nrpe config snippets, avoid repeating details.
#
define nagios::client::nrpe (
    $plugin_dir = '/usr/libexec/nagios/plugins',
    $plugin     = $name,
    $template   = 'check_generic',
    $command    = $name,
    $sudo       = false,
    $args       = false
) {

    file { "/etc/nagios/nrpe.d/nrpe-${title}.cfg":
        owner   => 'root',
        group   => $nagios::client::nrpe_group,
        mode    => '0640',
        content => template("nagios/nrpe-${template}.cfg.erb"),
        notify  => Service['nrpe'],
    }

}

