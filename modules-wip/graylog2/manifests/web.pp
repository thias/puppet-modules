# Requirements :
# * extract the release to /opt/graylog2-web
# * have the user pre-created
# cd /opt/graylog2-web
# chown -R root. .
# mkdir log
# chown graylog2. log
# bundle install --deployment
#
class graylog2::web (
    $user = 'graylog2',
    $thin = true,
    $thin_environment = 'production',
    # sysconfig
    $mongoid_host = 'localhost',
    $mongoid_port = '27017',
    $mongoid_username = undef,
    $mongoid_password = undef,
    $mongoid_database = 'graylog2'
) {

    # Required for the "bundle install --deployment" to work
    package { 'rubygem-bundler': ensure => installed }

    if $thin == true {
        package { 'rubygem-thin': ensure => installed }
    }

    file { '/etc/init.d/graylog2-web':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('graylog2/graylog2-web.init.erb'),
    }
    file { '/etc/sysconfig/graylog2-web':
        owner   => 'root',
        group   => $user,
        mode    => '0640',
        content => template('graylog2/graylog2-web.sysconfig.erb'),
    }
    service { 'graylog2-web':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => [
            File['/etc/init.d/graylog2-web'],
            File['/etc/sysconfig/graylog2-web'],
        ],
    }

}

