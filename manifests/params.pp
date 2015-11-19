# Class: vsftpd::params
#
class vsftpd::params {

  $package_name = 'vsftpd'
  $service_name = 'vsftpd'

  case $::operatingsystem {
    'RedHat',
    'CentOS',
    'Amazon': {
      $confdir = '/etc/vsftpd'
    }
    'Debian',
    'Ubuntu': {
      $confdir = '/etc'
    }
    default: {
      $confdir = '/etc/vsftpd'
    }
  }

  $anonymous_enable          =  'YES'
  $local_enable              =  'NO'
  $write_enable              =  'NO'
  $local_umask               =  '077'
  $anon_upload_enable        =  'NO'
  $anon_mkdir_write_enable   =  'NO'
  $dirmessage_enable         =  'NO'
  $xferlog_enable            =  'NO'
  $connect_from_port_20      =  'NO'
  $chown_uploads             =  'NO'
  $chown_username            =  'root'
  $xferlog_file              =  '/var/log/xferlog'
  $xferlog_std_format        =  'NO'
  $idle_session_timeout      =  '300'
  $data_connection_timeout   =  '300'
  $nopriv_user               =  'nobody'
  $async_abor_enable         =  'NO'
  $ascii_upload_enable       =  'NO'
  $ascii_download_enable     =  'NO'
  $ftpd_banner               =  undef
  $chroot_local_user         =  'NO'
  $chroot_list_enable        =  'NO'
  $chroot_list_file          =  '/etc/vsftpd/chroot_list'
  $ls_recurse_enable         =  'NO'
  $listen                    =  'NO'
  $listen_port               =  '21'
  $pam_service_name          =  'ftp'
  $userlist_enable           =  'NO'
  $userlist_deny             =  'YES'
  $tcp_wrappers              =  'NO'
  $hide_file                 =  undef
  $hide_ids                  =  'NO'
  $setproctitle_enable       =  'NO'
  $text_userdb_names         =  'NO'
  $max_clients               =  '0'
  $max_per_ip                =  '0'
  $pasv_min_port             =  '0'
  $pasv_max_port             =  '0'
  $ftp_username              =  'ftp'
  $banner_file               =  undef
  $ssl_request_cert          =  'YES'
  $allow_writeable_chroot    =  undef
  $anon_other_write_enable   =  'NO'
  $anon_world_readable_only  =  'YES'
  $background                =  'YES'
  $check_shell               =  'YES'
  $chmod_enable              =  'YES'
  $deny_email_enable         =  'NO'
  $dirlist_enable            =  'YES'
  $download_enable           =  'YES'
  $dual_log_enable           =  'NO'
  $force_dot_files           =  'NO'
  $force_anon_data_ssl       =  'NO'
  $force_anon_logins_ssl     =  'NO'
  $force_local_data_ssl      =  'YES'
  $force_local_logins_ssl    =  'YES'
  $guest_enable              =  'NO'
  $listen_ipv6               =  'NO'
  $lock_upload_files         =  'NO'
  $log_ftp_protocol          =  'NO'
  $mdtm_write                =  'YES'
  $no_anon_password          =  'NO'
  $no_log_lock               =  'NO'
  $one_process_model         =  'NO'
  $passwd_chroot_enable      =  'NO'
  $pasv_addr_resolve         =  'NO'
  $pasv_enable               =  'YES'
  $pasv_promiscuous          =  'NO'
  $port_enable               =  'YES'
  $port_promiscuous          =  'NO'
  $reverse_lookup_enable     =  'YES'
  $run_as_launching_user     =  'NO'
  $secure_email_list_enable  =  'NO'
  $session_support           =  'NO'
  $ssl_enable                =  'NO'
  $ssl_sslv2                 =  'NO'
  $ssl_sslv3                 =  'NO'
  $ssl_tlsv1                 =  'YES'
  $syslog_enable             =  'NO'
  $tilde_user_enable         =  'NO'
  $use_localtime             =  'NO'
  $use_sendfile              =  'YES'
  $userlist_log              =  'NO'
  $virtual_use_local_privs   =  'NO'
  $accept_timeout            =  '60'
  $anon_max_rate             =  '0'
  $anon_umask                =  '077'
  $connect_timeout           =  '60'
  $delay_failed_login        =  '1'
  $delay_successful_login    =  '0'
  $file_open_mode            =  '0666'
  $ftp_data_port             =  '20'
  $local_max_rate            =  '0'
  $max_login_fails           =  '3'
  $trans_chunk_size          =  '0'
  $anon_root                 =  undef
  $banned_email_file         =  '/etc/vsftpd/banned_emails'
  $cmds_allowed              =  undef
  $deny_file                 =  undef
  $dsa_cert_file             =  undef
  $dsa_private_key_file      =  undef
  $email_password_file       =  '/etc/vsftpd/email_passwords'
  $guest_username            =  'ftp'
  $listen_address            =  undef
  $listen_address6           =  undef
  $local_root                =  undef
  $message_file              =  '.message'
  $pasv_address              =  undef
  $rsa_cert_file             =  '/usr/share/ssl/certs/vsftpd.pem'
  $rsa_private_key_file      =  undef
  $secure_chroot_dir         =  '/usr/share/empty'
  $ssl_ciphers               =  'DES-CBC3-SHA'
  $user_config_dir           =  undef
  $user_sub_token            =  undef
  $userlist_file             =  '/etc/vsftpd/user_list'
  $vsftpd_log_file           =  '/var/log/vsftpd.log'

}

