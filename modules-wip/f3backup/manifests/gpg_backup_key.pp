class f3backup::gpg_backup_key {
    include gpg
    gpg::install_key { 'backup': }
}

