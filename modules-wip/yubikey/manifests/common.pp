# Class: yubikey::common
#
class yubikey::common inherits ::yubikey::params {

  # Trivial PHP configuration
  php::ini { '/etc/php.ini': }
  php::module { [ 'mcrypt', 'mysql' ]: }

  # Simple Apache HTTPD configuration suitable for PHP
  class { '::php::mod_php5': }
  class { '::apache_httpd':
    modules => [
      'auth_basic',
      'authn_file',
      'authz_host',
      'authz_user',
      'mime',
      'negotiation',
      'dir',
      'alias',
      'rewrite',
      'proxy',
    ],
    welcome => false,
  }

  apache_httpd::file { 'yubikey.conf':
    content => template('yubikey/httpd-yubikey.conf.erb'),
  }

  # MySQL server
  if $mysql_server == true {
    class { 'mysql::server':
      #config_hash => { 'root_password' => 'Jzfbtyu1_0' },
      config_hash => $mysql_config_hash,
    }
    if $mysql_settings != '' {
      mysql::server::config { $module_name:
        settings => $mysql_settings,
      }
    }
  }

  # The main web directory
  file { $wsapi_root:
    ensure  => directory,
    require => Package['httpd'],
  }

}

