# Class: vsftpd
#
# Install, enable and configure a vsftpd FTP server instance.
#
# Parameters:
#  see vsftpd.conf(5) for details about what the available parameters do.
# Sample Usage :
#  include vsftpd
#  class { 'vsftpd':
#    anonymous_enable  => 'NO',
#    write_enable      => 'YES',
#    ftpd_banner       => 'Marmotte FTP Server',
#    chroot_local_user => 'YES',
#  }
#
class vsftpd (
  $confdir                 = $::vsftpd::params::confdir,
  $package_name            = $::vsftpd::params::package_name,
  $service_name            = $::vsftpd::params::service_name,
  $template                = 'vsftpd/vsftpd.conf.erb',
  # vsftpd.conf options
  $anonymous_enable        = 'YES',
  $local_enable            = 'YES',
  $write_enable            = 'YES',
  $local_umask             = '022',
  $anon_upload_enable      = 'NO',
  $anon_mkdir_write_enable = 'NO',
  $dirmessage_enable       = 'YES',
  $xferlog_enable          = 'YES',
  $connect_from_port_20    = 'YES',
  $chown_uploads           = 'NO',
  $chown_username          = undef,
  $xferlog_file            = '/var/log/vsftpd.log',
  $xferlog_std_format      = 'YES',
  $idle_session_timeout    = '600',
  $data_connection_timeout = '120',
  $nopriv_user             = undef,
  $async_abor_enable       = 'NO',
  $ascii_upload_enable     = 'NO',
  $ascii_download_enable   = 'NO',
  $ftpd_banner             = undef,
  $guest_enable            = 'NO',
  $virtual_use_local_privs = 'YES',
  $log_ftp_protocol        = 'NO',
  # intentionally not interpolated
  $user_sub_token          = '$USER',
  $local_root              = '/ftp/virtual/$USER',
  $chroot_local_user       = 'NO',
  $chroot_list_enable      = 'NO',
  $chroot_list_file        = '/etc/vsftpd/chroot_list',
  $ls_recurse_enable       = 'NO',
  $listen                  = 'YES',
  $listen_port             = undef,
  $pam_service_name        = 'vsftpd',
  $userlist_enable         = 'YES',
  $userlist_deny           = undef,
  $tcp_wrappers            = 'YES',
  $hide_file               = undef,
  $hide_ids                = 'NO',
  $setproctitle_enable     = 'NO',
  $text_userdb_names       = 'NO',
  $max_clients             = undef,
  $max_per_ip              = undef,
  $pasv_min_port           = undef,
  $pasv_max_port           = undef,
  $ftp_username            = undef,
  $banner_file             = undef,
  $allow_writeable_chroot  = undef,
  $directives              = {},
) inherits ::vsftpd::params {

  package { $package_name: ensure => installed }

  service { $service_name:
    require   => Package[$package_name],
    enable    => true,
    ensure    => running,
    hasstatus => true,
  }

  file { "${confdir}/vsftpd.conf":
    require => Package[$package_name],
    content => template($template),
    notify  => Service[$service_name],
  }

}

