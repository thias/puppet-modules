# Class: yubikey::val
#
# Install, configure and manage a yubikey Validation server.
#
# Parameters:
#
# Sample Usage :
#  include yubikey::val
#
class yubikey::val (
  $db_dsn            = 'mysql:dbname=ykval',
  $db_username       = 'ykval',
  $db_password,
  $sync_pool         = 'array()',
  $allowed_sync_pool = 'array()',
  $otp_to_ksmurls    = 'return array("http://localhost/wsapi/decrypt?otp=$otp")',
) inherits ::yubikey::params {

  include '::yubikey::common'

  package { 'yubikey-val': ensure => installed }

  file { '/etc/ykval/ykval-config.php':
    owner   => 'root',
    group   => 'apache',
    mode    => '0640',
    content => template('yubikey/ykval-config.php.erb'),
    require => [
      Package['yubikey-val'],
      Package['httpd'],
    ],
  }

  if $mysql_server == true {
    mysql::db { 'ykval':
      user     => $db_username,
      password => $db_password,
      host     => 'localhost',
      # FIXME: See GRANTs from the Installation wiki page
      grant    => [ 'insert_priv', 'select_priv', 'update_priv', ],
    }
  }

  # The sub-directory
  file { "${wsapi_root}/2.0":
    ensure  => directory,
  }
#  file { '/var/www/html/wsapi/2.0/.htaccess':
#    owner   => 'root',
#    group   => 'root',
#    mode    => '0644',
#    source => 'puppet:///modules/yubikey/val/htaccess',
#  }
  # The main scripts
  file { "${wsapi_root}/2.0/sync.php":
    ensure => link,
    target => '/usr/share/ykval/ykval-sync.php',
  }
  file { "${wsapi_root}/2.0/verify.php":
    ensure => link,
    target => '/usr/share/ykval/ykval-verify.php',
  }

}

