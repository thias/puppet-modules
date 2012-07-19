# Class: couchbase::install
#
# Install the required packages, scripts and users for Couchbase Server.
#
class couchbase::install ( $rpmbasename, $rpmbaseurl ) {

    if $::operatingsystem == 'Gentoo' {

        # We use the official binary rpm package...
        $basedir = $couchbase::params::basedir
        file { '/etc/init.d/couchbase-server':
            mode    => '0755',
            content => template('couchbase/gentoo/couchbase-server-init.d.erb'),
            require => Exec['install-couchbase-from-rpm'],
        }
        file { '/etc/conf.d/couchbase-server':
            content => template('couchbase/gentoo/couchbase-server-conf.d.erb'),
            notify  => Service['couchbase-server'],
        }
        user { 'couchbase':
            comment => 'couchbase system user',
            home    => $basedir,
            shell   => '/sbin/nologin',
            system  => true,
        }
        exec { 'install-couchbase-from-rpm':
            command => "mkdir couchbase; cd couchbase && wget -q ${rpmbaseurl}/${rpmbasename}.rpm && rpm2tar ${rpmbasename}.rpm && tar xf ${rpmbasename}.tar && mv opt/couchbase ${basedir} && chown -R couchbase: ${basedir}; rm -rf /tmp/couchbase",
            creates => $basedir,
            cwd     => '/tmp',
            path    => [ '/bin', '/usr/bin' ],
            require => User['couchbase'],
        }

    } else {

        # This is the clean way
        package { 'couchbase-server': ensure => installed }

    }

}

