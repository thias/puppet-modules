# Define: nfs::v3mount
#
define nfs::v3mount (
    $device,
    $ensure   = 'mounted',
    $options  = 'tcp,hard,intr,nfsvers=3',
    $pass     = '0',
    $dirowner = 'root',
    $dirgroup = 'root',
    $dirmode  = '0755'
) {

    include nfs::v3client

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
            # This is v3 only!
            Service['rpcbind'],
            Service['nfslock'],
        ],
        device  => $device,
        ensure  => $ensure,
        fstype  => 'nfs',
        name    => $title,
        options => $options,
        pass    => $pass,
    }

}

