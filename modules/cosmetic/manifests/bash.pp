# Class: cosmetic::bash
#
# Modify globally some simple cosmetic aspects of the bash shell.
#
# Sample Usage :
#  include cosmetic::bash
#  class { 'cosmetic::bash':
#      # Red prompt
#      ps1 => '\[\033[1;31m\][\u@\h \W]\[\033[0m\]\\$ ',
#  }
#
class cosmetic::bash (
    $histtimeformat = '%Y%m%d %H:%M:%S ',
    $ps1            = false,
    $ensure         = 'present'
) {

    if $ensure == 'absent' {
        file { '/etc/profile.d/cosmetic.sh': ensure => absent }
    } else {
        file { '/etc/profile.d/cosmetic.sh':
            content => template('cosmetic/cosmetic.sh.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

}

