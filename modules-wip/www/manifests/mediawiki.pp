# Install MediaWiki data files.
#
# Sample Usage :
#     www::mediawiki { '/var/www/html/wiki/w': version => '1.18.0' }
#
# You need to make sure the parent directory exists, as it won't get created
# automatically.
#
define www::mediawiki (
    $version = '1.18.0'
) {
    $basedir = $title
    # Needed in the URL below
    $major_version = regsubst($version, '^(.+)\.\d+$', '\1')
    # Using mktemp would be best, I just haven't managed yet
    $random = fqdn_rand(10000)
    $tmpdir = "/tmp/mediawiki-${random}"
    exec { "mkdir ${tmpdir} && cd ${tmpdir} && wget http://download.wikimedia.org/mediawiki/${major_version}/mediawiki-${version}.tar.gz && tar xzvf mediawiki-${version}.tar.gz && mv mediawiki-${version} ${basedir}; rm -rf ${tmpdir}; [ -x /sbin/restorecon ] && /sbin/restorecon -R ${basedir}":
        alias   => 'install-mediawiki',
        path    => [ '/bin', '/usr/bin' ],
        creates => $basedir,
    }
}

