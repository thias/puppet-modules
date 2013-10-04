# Define: nfs::v4mount
#
define nfs::v4mount (
    $device,
    $ensure   = 'mounted',
    $options  = 'tcp,hard,intr',
    $pass     = '0',
    $dirowner = 'root',
    $dirgroup = 'root',
    $dirmode  = '0755'
) {

    # Mount point
    file { $title:
        ensure => directory,
        owner  => $dirowner,
        group  => $dirgroup,
        mode   => $dirmode,
    }

    mount { $title:
        require => [
            File[$title],
            Service['rpcidmapd'],
            Class['nfs::v4client'],
            # This is v3 only?
            #Service['nfslock']
        ],
        device  => $device,
        ensure  => $ensure,
        fstype  => 'nfs',
        name    => $title,
        options => $options,
        pass    => $pass,
    }

}

