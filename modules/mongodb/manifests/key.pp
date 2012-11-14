# Define: mongodb::key
#
# Example Usage:
#   mongodb::key { '/etc/mongodb.key': content => 'foo' }
#
define mongodb::key (
    $content = undef,
    $source = undef,
    $ensure = undef
) {

    file { $title:
        content => $content,
        source  => $source,
        # mongod requires 0600, anything more relaxed won't work
        mode    => '0600',
        owner   => 'mongodb',
        group   => 'mongodb',
        require => Package['mongodb-server'],
        notify  => Service['mongod'],
        ensure  => $ensure,
    }

}

