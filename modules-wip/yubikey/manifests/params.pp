# Class: yubikey::params
#
class yubikey::params (
  $wsapi_root        = '/var/www/html/wsapi',
  $mysql_server      = true,
  $mysql_config_hash = { 'root_password' => 'Jzfbtyu1_0' },
  $mysql_settings    = {
    'mysqld' => {
      'skip-networking' => true,
      'skip-innodb' => true,
    },
  },
) {

}

