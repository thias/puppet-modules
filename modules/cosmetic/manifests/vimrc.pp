# Class: cosmetic::vimrc
#
# Modify the main vimrc file with custom defaults.
#
# Sample Usage :
#  include cosmetic::vimrc
#
class cosmetic::vimrc (
    $lines = [
        'set expandtab',
        'set tabstop=4',
        'set shiftwidth=4',
        ':sy on',
    ]
) {

    file { '/etc/vimrc':
        content => template('cosmetic/vimrc.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}

