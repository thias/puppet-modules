# Install FusionBPX data files.
#
# Sample Usage :
#     www::fusionpbx{ '/var/www/html/fusionpbx': version => '2.0.9' }
#
# You need to make sure the parent directory exists, as it won't get created
# automatically.
#
define www::fusionpbx (
    $version = '2.0.9'
) {
    $basedir = $title
    # Using mktemp would be best, I just haven't managed yet
    $random = fqdn_rand(10000)
    $tmpdir = "/tmp/fusionpbx-${random}"
    exec { "mkdir ${tmpdir} && cd ${tmpdir} && wget http://fusionpbx.googlecode.com/files/fusionpbx-${version}.tar.gz && tar xzvf fusionpbx-${version}.tar.gz && mv fusionpbx ${basedir}; rm -rf ${tmpdir}; [ -x /sbin/restorecon ] && /sbin/restorecon -R ${basedir}":
        alias   => 'install-fusionpbx',
        path    => [ '/bin', '/usr/bin' ],
        creates => $basedir,
    }
}

