# Install phpMyAdmin data files.
#
# $variant can be 'english' (default) or 'all-languages'
#
# Sample Usage :
#     www::phpmyadmin { '/var/www/html/phpmyadmin': version => '3.5.3' }
#
# You need to make sure the parent directory exists, as it won't get created
# automatically.
#
define www::phpmyadmin (
    $version = '3.5.3',
    $variant = 'english'
) {
    $basedir = $title
    # Using mktemp would be best, I just haven't managed yet
    $random = fqdn_rand(10000)
    $tmpdir = "/tmp/phpmyadmin-${random}"
    exec { 'install-phpmyadmin':
        command => "mkdir ${tmpdir} && cd ${tmpdir} && wget http://downloads.sf.net/phpmyadmin/phpMyAdmin/${version}/phpMyAdmin-${version}-${variant}.tar.gz && tar xzf phpMyAdmin-${version}-${variant}.tar.gz && mv phpMyAdmin-${version}-${variant} ${basedir}; rm -rf ${tmpdir}; [ -x /sbin/restorecon ] && /sbin/restorecon -R ${basedir}",
        path    => [ '/bin', '/usr/bin' ],
        creates => $basedir,
    }
}

