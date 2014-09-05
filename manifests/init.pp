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
  $package_name              = 'USE_DEFAULTS',
  $service_name              = 'USE_DEFAULTS',
  $confdir                   = 'USE_DEFAULTS',
  $template                  = 'vsftpd/vsftpd.conf.erb',
  # vsftpd.conf options
  $anon_mkdir_write_enable   = 'NO',
  $anon_upload_enable        = 'NO',
  $anonymous_enable          = 'YES',
  $ascii_upload_enable       = 'NO',
  $ascii_download_enable     = 'NO',
  $async_abor_enable         = 'NO',
  $chown_uploads             = 'NO',
  $chroot_list_enable        = 'NO',
  $chroot_local_user         = 'NO',
  $connect_from_port_20      = 'YES',
  $dirmessage_enable         = 'YES',
  $hide_ids                  = 'NO',
  $listen                    = 'YES',
  $local_enable              = 'YES',
  $ls_recurse_enable         = 'NO',
  $setproctitle_enable       = 'NO',
  $tcp_wrappers              = 'YES',
  $text_userdb_names         = 'NO',
  $userlist_deny             = 'YES',
  $userlist_enable           = 'NO',
  $write_enable              = 'YES',
  $xferlog_enable            = 'YES',
  $xferlog_std_format        = 'YES',
  $data_connection_timeout   = '300',
  $idle_session_timeout      = '300',
  $listen_port               = '21',
  $local_umask               = '022',
  $max_clients               = '2000',
  $max_per_ip                = '50',
  $pasv_max_port             = '0',
  $pasv_min_port             = '0',
  $banner_file               = undef,
  $chown_username            = undef,
  $chroot_list_file          = '/etc/vsftpd/chroot_list',
  $ftpd_banner               = undef,
  $ftp_username              = 'ftp',
  $hide_file                 = undef,
  $nopriv_user               = 'nobody',
  $pam_service_name          = 'vsftpd',
  $userlist_file             = '/etc/vsftpd/user_list',
  $xferlog_file              = '/var/log/xferlog',
  $allow_writeable_chroot    = undef,
  $directives                = {},
  $manage_userlist_file      = undef,
  $userlist_users            = undef,
) {

  case $::operatingsystem {
    'RedHat',
    'CentOS',
    'Amazon': {
      $default_package_name = 'vsftpd'
      $default_service_name = 'vsftpd'
      $default_confdir      = '/etc/vsftpd'
    }
    'Debian',
    'Ubuntu': {
      $default_package_name = 'vsftpd'
      $default_service_name = 'vsftpd'
      $default_confdir      = '/etc'
    }
    default: {
      fail("vim supports OS , RedHat, CentOS, Amazon, Debian and Ubuntu. Detected operatingsystem is <${::operatingsystem}>.")
    }
  }

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $default_package_name
  } else {
    $package_name_real = $package_name
  }

  if $service_name == 'USE_DEFAULTS' {
    $service_name_real = $default_service_name
  } else {
    $service_name_real = $service_name
  }

  if $confdir == 'USE_DEFAULTS' {
    $confdir_real = $default_confdir
  } else {
    $confdir_real = $confdir
  }

  validate_re($anon_mkdir_write_enable, '^(YES|NO)$',
    "vsftpd::anon_mkdir_write_enable is <${anon_mkdir_write_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($anon_upload_enable, '^(YES|NO)$',
    "vsftpd::anon_upload_enable is <${anon_upload_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($anonymous_enable, '^(YES|NO)$',
    "vsftpd::anonymous_enable is <${anonymous_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($ascii_upload_enable, '^(YES|NO)$',
    "vsftpd::ascii_upload_enable is <${ascii_upload_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($ascii_download_enable, '^(YES|NO)$',
    "vsftpd::ascii_download_enable is <${ascii_download_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($async_abor_enable, '^(YES|NO)$',
    "vsftpd::async_abor_enable is <${async_abor_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($chown_uploads, '^(YES|NO)$',
    "vsftpd::chown_uploads is <${chown_uploads}>. Must be either 'YES' or 'NO'.")
  validate_re($chroot_list_enable, '^(YES|NO)$',
    "vsftpd::chroot_list_enable is <${chroot_list_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($chroot_local_user, '^(YES|NO)$',
    "vsftpd::chroot_local_user is <${chroot_local_user}>. Must be either 'YES' or 'NO'.")
  validate_re($connect_from_port_20, '^(YES|NO)$',
    "vsftpd::connect_from_port_20 is <${connect_from_port_20}>. Must be either 'YES' or 'NO'.")
  validate_re($dirmessage_enable, '^(YES|NO)$',
    "vsftpd::dirmessage_enable is <${dirmessage_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($hide_ids, '^(YES|NO)$',
    "vsftpd::hide_ids is <${hide_ids}>. Must be either 'YES' or 'NO'.")
  validate_re($listen, '^(YES|NO)$',
    "vsftpd::listen is <${listen}>. Must be either 'YES' or 'NO'.")
  validate_re($local_enable, '^(YES|NO)$',
    "vsftpd::local_enable is <${local_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($ls_recurse_enable, '^(YES|NO)$',
    "vsftpd::ls_recurse_enable is <${ls_recurse_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($setproctitle_enable, '^(YES|NO)$',
    "vsftpd::setproctitle_enable is <${setproctitle_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($tcp_wrappers, '^(YES|NO)$',
    "vsftpd::tcp_wrappers is <${tcp_wrappers}>. Must be either 'YES' or 'NO'.")
  validate_re($text_userdb_names, '^(YES|NO)$',
    "vsftpd::text_userdb_names is <${text_userdb_names}>. Must be either 'YES' or 'NO'.")
  validate_re($userlist_deny, '^(YES|NO)$',
    "vsftpd::userlist_deny is <${userlist_deny}>. Must be either 'YES' or 'NO'.")
  validate_re($userlist_enable, '^(YES|NO)$',
    "vsftpd::userlist_enable is <${userlist_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($write_enable, '^(YES|NO)$',
    "vsftpd::write_enable is <${write_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($xferlog_enable, '^(YES|NO)$',
    "vsftpd::xferlog_enable is <${xferlog_enable}>. Must be either 'YES' or 'NO'.")
  validate_re($xferlog_std_format, '^(YES|NO)$',
    "vsftpd::xferlog_std_format is <${xferlog_std_format}>. Must be either 'YES' or 'NO'.")

  validate_re($data_connection_timeout, '^(\d)+$',
    "vsftpd::data_connection_timeout is <${data_connection_timeout}>. Must be a number.")
  validate_re($idle_session_timeout, '^(\d)+$',
    "vsftpd::idle_session_timeout is <${idle_session_timeout}>. Must be a number.")
  validate_re($listen_port, '^(\d)+$',
    "vsftpd::listen_port is <${listen_port}>. Must be a number.")
  validate_re($local_umask, '^(\d)+$',
    "vsftpd::local_umask is <${local_umask}>. Must be a number.")
  validate_re($max_clients, '^(\d)+$',
    "vsftpd::max_clients is <${max_clients}>. Must be a number.")
  validate_re($max_per_ip, '^(\d)+$',
    "vsftpd::max_per_ip is <${max_per_ip}>. Must be a number.")
  validate_re($pasv_max_port, '^(\d)+$',
    "vsftpd::pasv_max_port is <${pasv_max_port}>. Must be a number.")
  validate_re($pasv_min_port, '^(\d)+$',
    "vsftpd::pasv_min_port is <${pasv_min_port}>. Must be a number.")

  validate_string($banner_file)
  validate_string($chown_username)
  validate_absolute_path($chroot_list_file)
  validate_string($ftp_username)
  validate_string($ftpd_banner)
  validate_string($hide_file)
  validate_string($nopriv_user)
  validate_string($pam_service_name)
  validate_absolute_path($userlist_file)
  validate_absolute_path($xferlog_file)

  if $manage_userlist_file {
    $userlist_users_type = type($userlist_users)
    if $userlist_users_type != 'string' and $userlist_users_type != 'array' {
      fail("vsftpd::userlist_users must be a string and an array. Detected type is <${userlist_users_type}>.")
    }
  }

  package { 'vsftpd_package':
    ensure => 'installed',
    name   => $package_name_real,
  }

  service { 'vsftpd_service':
    ensure    => 'running',
    name      => $service_name_real,
    enable    => true,
    hasstatus => true,
    require   => Package['vsftpd_package'],
  }

  file { 'vsftpd_conf':
    ensure  => 'file',
    path    => "${confdir_real}/vsftpd.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['vsftpd_package'],
    notify  => Service['vsftpd_service'],
  }

  if $manage_userlist_file {
    file { 'userlist_file':
      ensure  => 'file',
      path    => $userlist_file,
      content => template('vsftpd/user_list.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Package['vsftpd_package'],
    }

    file { 'ftpusers':
      ensure  => 'file',
      path    => "${confdir_real}/ftpusers",
      content => template('vsftpd/ftpusers.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Package['vsftpd_package'],
    }
  }
}
