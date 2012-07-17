# Define: nagios::client::nrpe_file
#
# Install check-specific client nrpe configuration snippet files.
#
define nagios::client::nrpe_file (
    $plugin     = $name,
    $template   = 'check_generic',
    $command    = $name,
    $sudo       = false,
    $args       = false,
    $ensure     = undef
) {

    file { "${nagios::params::nrpe_cfg_dir}/nrpe-${title}.cfg":
        owner   => 'root',
        group   => $nagios::client::nrpe_group,
        mode    => '0640',
        content => template("nagios/nrpe-${template}.cfg.erb"),
        notify  => Service['nrpe'],
        ensure  => $ensure,
    }

}

