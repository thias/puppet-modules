class nagios::plugin::dir_status {

  # Multiple checks need this file
  file { "${nagios::client::plugin_dir}/check_dir_status":
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/plugins/check_dir_status"),
  }

}

