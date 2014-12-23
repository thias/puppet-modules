# Class: yubikey::ksm
#
# Install, configure and manage a yubikey Key Storage Module server.
#
# Parameters:
#
# Sample Usage :
#  include yubikey::ksm
#
class yubikey::ksm (
  $db_dsn      = 'mysql:dbname=ykksm',
  $db_username = 'ykksm',
  $db_password,
) inherits ::yubikey::params {

  include ::yubikey::common

  package { 'yubikey-ksm': ensure => installed }

  file { '/etc/ykksm/ykksm-config.php':
    owner   => 'root',
    group   => 'apache',
    mode    => '0640',
    content => template('yubikey/ykksm-config.php.erb'),
    require => [
      Package['yubikey-ksm'],
      Package['httpd'],
    ],
  }

  if $mysql_server == true {
    mysql::db { 'ykksm':
      user     => $db_username,
      password => $db_password,
      host     => 'localhost',
      grant    => [ 'select_priv' ],
    }
  }

#  # This is the same as /usr/share/doc/yubikey-ksm-*/htaccess
#  file { '/var/www/html/wsapi/.htaccess':
#    owner   => 'root',
#    group   => 'root',
#    mode    => '0644',
#    source => 'puppet:///modules/yubikey/ksm/htaccess',
#  }
  # The main script
  file { "${wsapi_root}/decrypt.php":
    ensure => link,
    target => '/usr/share/ykksm/ykksm-decrypt.php',
  }

}

