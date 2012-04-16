define postfix::file () {

    file { "/etc/postfix/${title}":
        owner   => "root",
        group   => "root",
        mode    => 0644,
        content => template("postfix/files/${fqdn}/${title}"),
        notify  => Service["postfix"],
    }

}

