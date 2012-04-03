# Class: vsftpd
#
# Install, enable and configure a vsftpd FTP server instance.
#
# Parameters:
#  see vsftpd.conf(5) for details about what the available parameters do.
# Sample Usage :
#  include vsftpd
#  class { 'vsftpd':
#      anonymous_enable  => 'NO',
#      write_enable      => 'YES',
#      ftpd_banner       => 'Marmotte FTP Server',
#      chroot_local_user => 'YES',
#  }
#
class vsftpd (
    $anonymous_enable = 'YES',
    $local_enable = 'YES',
    $write_enable = 'YES',
    $local_umask = '022',
    $anon_upload_enable = 'NO',
    $anon_mkdir_write_enable = 'NO',
    $dirmessage_enable = 'YES',
    $xferlog_enable = 'YES',
    $connect_from_port_20 = 'YES',
    $chown_uploads = 'NO',
    $chown_username = false,
    $xferlog_file = '/var/log/vsftpd.log',
    $xferlog_std_format = 'YES',
    $idle_session_timeout = '600',
    $data_connection_timeout = '120',
    $nopriv_user = false,
    $async_abor_enable = 'NO',
    $ascii_upload_enable = 'NO',
    $ascii_download_enable = 'NO',
    $ftpd_banner = false,
    $chroot_local_user = 'NO',
    $chroot_list_enable = 'NO',
    $chroot_list_file = '/etc/vsftpd/chroot_list',
    $ls_recurse_enable = 'NO',
    $listen_port = false,
    $pam_service_name = 'vsftpd',
    $userlist_enable = 'YES',
    $tcp_wrappers = 'YES',
    $hide_ids = 'NO',
    $setproctitle_enable = 'NO',
    $text_userdb_names = 'NO'
) {

    package { 'vsftpd': ensure => installed }

    service { 'vsftpd':
        require   => Package['vsftpd'],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

    file { '/etc/vsftpd/vsftpd.conf':
        require => Package['vsftpd'],
        content => template('vsftpd/vsftpd.conf.erb'),
        notify  => Service['vsftpd'],
    }

}

