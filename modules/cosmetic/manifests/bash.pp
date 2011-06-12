# Class to modify globally some simple cosmetic aspects of the bash shell.
#
# Sample Usage :
#     include cosmetic::bash
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
            mode    => '0755',
        }
    }

}

