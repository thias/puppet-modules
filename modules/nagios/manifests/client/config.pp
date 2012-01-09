# Create nagios specific configuration by using nagios_* facts
define nagios::client::config ( $value ) {
    file { "/etc/nagios/facter/${title}.conf":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        # Cosmetic, a "cat" of the files will be readable with \n
        content => "${value}\n",
        require => File['/etc/nagios/facter'],
    }
}

