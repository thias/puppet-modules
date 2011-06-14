# Manage Private Key Infrastructure (PKI) Transport Layer Security (TLS) files.
#
# Sample Usage :
#
define tlsfiles (
    $crtpath = '/etc/pki/tls/certs',
    $keypath = '/etc/pki/tls/private',
    $crtmode = '0644',
    $keymode = '0600',
    $owner   = 'root',
    $group   = 'root',
    $intcert = false,
    $intjoin = false,
    $pem     = false,
    $srcdir  = 'tlsfiles'
) {
    # Use the definition's title as the CN which is also the file name
    $cn = $title
    # For PEM, we group crt+key(+intcert) in a single file
    if $pem {
        $pemcontent = $intcert ? {
            true  => template("${srcdir}/crt/${cn}.crt","${srcdir}/key/${cn}.key","${srcdir}/crt/${intcert}.crt"),
            false => template("${srcdir}/crt/${cn}.crt","${srcdir}/key/${cn}.key"),
        }
        # PEM file
        file { "${keypath}/${cn}.pem":
            owner   => $owner,
            group   => $group,
            mode    => $keymode,
            content => $pemcontent,
        }
    } else {
        # Key file
        file { "${keypath}/${cn}.key":
            owner   => $owner,
            group   => $group,
            mode    => $keymode,
            content => template("${srcdir}/key/${cn}.key"),
        }
        # Crt files (+ Intermediate)
        $crtcontent = $intjoin ? {
            true  => template("${srcdir}/crt/${cn}.crt","${srcdir}/crt/${intcert}.crt"),
            false => template("${srcdir}/crt/${cn}.crt"),
        }
        file { "${crtpath}/${cn}.crt":
            owner   => $owner,
            group   => $group,
            mode    => $crtmode,
            content => $crtcontent,
        }
        # Intermediate, when not joined
        if $intcert != false and $intjoin == false {
            file { "${crtpath}/${intcert}.crt":
                owner   => $owner,
                group   => $group,
                mode    => $crtmode,
                content => template("${srcdir}/crt/${intcert}.crt"),
            }
        }
    }
}

