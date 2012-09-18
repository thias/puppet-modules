# Define: dovecot::plugin
#
# Trivial way to install plugin sub-packages.
# Should only be used as the 'plugins' parameter of the main dovecot class.
#
# Example Usage:
#     class { 'dovecot': plugins => [ 'mysql', 'pigeonhole' ] }
#
define dovecot::plugin() {
    package { "dovecot-${title}": ensure => installed }
}

