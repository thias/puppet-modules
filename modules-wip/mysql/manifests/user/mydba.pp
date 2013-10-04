class mysql::user::mydba {
    case $mysql_mydbapw {
        '': { fail("You need to define a mysql mydba password! Please set \$mysql_mydbapw in your site.pp or host config") }
    }

    mysql_user { "mydba@%":
        ensure => present,
        password_hash => mysql_password($mysql_mydbapw),
    }
    mysql_grant { "mydba@%":
        privileges => [ "select_priv", "insert_priv", "update_priv", "delete_priv", "create_priv", "drop_priv", "process_priv", "file_priv", "grant_priv", "index_priv", "alter_priv", "show_db_priv", "create_tmp_table_priv", "lock_tables_priv", "execute_priv", "create_view_priv", "show_view_priv", "create_routine_priv", "alter_routine_priv", "create_user_priv", "event_priv", "trigger_priv" ],
    }
}

