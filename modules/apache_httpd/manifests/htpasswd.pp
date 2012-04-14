# Define: apache_httpd::htpasswd
#
# Apache httpd server credential management definition.
#
# Parameters:
#  $file:
#    The full path to the database file. Default: none.
#  $username:
#    The username to add to the database. Default: none.
#  $password:
#    Encrypted password. Default: none.
#  $ensure:
#    Whether the credentials should be 'present' or 'absent'. 
#    Defaults to 'present'.
#
# Sample Usage :
#  apache_httpd::htpasswd { 'user1':
#     file     => '/etc/httpd/db1',
#     password => '$apr1$6JDUc2Vi$W1pTLxcwcSnv2z/psiNo91'
#  }
#
define apache_httpd::htpasswd (
    $file,
    $password,
    $username = $name,
    $ensure   = present
) {
    case $ensure {
      'present','absent': {}
      default: { fail ('Ensure can only be present or abset') }
    }

    $passwd = shellquote($password)
    Exec {
        path    => '/usr/bin:/bin',
    }

    if $ensure == 'present' {
      exec { "Add ${username}":
        command => "htpasswd -b -p ${file} ${username} ${passwd}",
        unless  => "grep ${username}:${passwd} ${file}",
      }
    } else {
      exec { "Remove ${username}":
        command => "htpasswd -D ${file} ${username}",
        onlyif  => "grep ${username} ${file}",
      }
    }
}

