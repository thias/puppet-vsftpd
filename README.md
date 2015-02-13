# puppet-vsftpd

From Latch Mihaylov (zverocool)

Enhanced funtionality to the vsftpd module to include FTPS compatbility and etc.
In summary 
1. enables you to select vsftpd version
2. Adding the chrooted directory to SELINUX if its enabled
3. enables FTPS support 
This is very light documentation and needs to be enhanced.

Examples (wrappers)
Regular FTP Server, defining version, chrooting, not so different from existing
```puppet
      class { 'vsftpd':
        version               => '2.2.2-11.el6_4.1',
        ftpd_banner           => 'FTP Server',
        anonymous_enable      => 'NO',
        chroot_local_user     => 'YES',
        local_root            => '/data/ftp/$USER',
        user_sub_token        => '$USER',
        local_enable          => 'YES',
        write_enable          => 'YES',
        local_umask           => '022',
        dirmessage_enable     => 'YES',
        xferlog_enable        => 'YES',
        connect_from_port_20  => 'YES',
        xferlog_std_format    => 'YES',
        listen                => 'YES',
        pam_service_name      => 'vsftpd',
        userlist_enable       => 'YES',
        userlist_log          => 'YES',
        tcp_wrappers          => 'NO',
        session_support       => 'YES',
      }
```
FTPS Server with version and chrooting
```puppet 
      # Various FTPS Variables
      $ftps_cert = 'ftps.cer'
      $ftps_key = 'ftps.key'

      # PASV Settings for FTPS
      $masquerade_min_port = '36000'
      $masquerade_max_port = '36999'
      $masquerade_address  = '127.0.0.1' #use your masq address here

      if $masquerade_address != undef {
        class { 'vsftpd':
          version               => '2.2.2-11.el6_4.1',
          ftpd_banner           => 'FTPS Server',
          anonymous_enable      => 'NO',
          chroot_local_user     => 'YES',
          local_root            => '/data/ftps/$USER',
          user_sub_token        => '$USER',
          local_enable          => 'YES',
          write_enable          => 'YES',
          local_umask           => '022',
          dirmessage_enable     => 'YES',
          xferlog_enable        => 'YES',
          connect_from_port_20  => 'YES',
          xferlog_std_format    => 'YES',
          listen                => 'YES',
          pam_service_name      => 'vsftpd',
          userlist_enable       => 'YES',
          userlist_log          => 'YES',
          tcp_wrappers          => 'NO',
          session_support       => 'YES',

          # SSL SUPPORT
          ssl_enable             => 'YES',
          rsa_cert_file          => "/etc/vsftpd/cert/$ftps_cert",
          rsa_private_key_file   => "/etc/vsftpd/cert/$ftps_key",
          require_ssl_reuse      => 'YES',
          allow_anon_ssl         => 'YES',
          force_local_data_ssl   => 'NO',
          force_local_logins_ssl => 'YES',
          ssl_tlsv1              => 'YES',
          ssl_sslv2              => 'NO',
          ssl_sslv3              => 'NO',
          ssl_ciphers            => 'HIGH',

          # Adding masquerade abilities for VIP
          pasv_min_port         => '13000',
          pasv_max_port         => '13999',
          pasv_address          => '127.0.0.1', # masquarade address here 127 is for the example
        }

        # ADDS THE CERT
        file { "$::vsftpd::params::confdir/cert/$ftps_cert":
          ensure  => present,
          source  => "puppet:///cert/${ftps_cert}",
          mode    => 0644,
          owner   => root,
          group   => root,
          notify  => Service[$::vsftpd::params::service_name],
        }

        # ADDS THE CERT KEY
        file { "$::vsftpd::params::confdir/cert/${ftps_key}":
          ensure  => present,
          source  => "puppet:///cert/${ftps_key}",
          mode    => 0644,
          owner   => root,
          group   => root,
          notify  => Service[$::vsftpd::params::service_name],
        }
```
## Overview

This module enables and configures a vsftpd FTP server instance.

* `vsftpd` : Enable and configure the vsftpd FTP server

## Examples

With all of the module's default settings :

```puppet
include vsftpd
```

Tweaking a few settings (have a look at `manifests/init.pp` to know which
directives are supported as parameters) :

```puppet
class { 'vsftpd':
  anonymous_enable  => 'NO',
  write_enable      => 'YES',
  ftpd_banner       => 'Marmotte FTP Server',
  chroot_local_user => 'YES',
}
```

For any directives which aren't directly supported by the module, use the
additional `directives` hash parameter :

```puppet
class { 'vsftpd':
  ftpd_banner => 'ASCII FTP Server',
  directives  => {
    'ascii_download_enable' => 'YES',
    'ascii_upload_enable'   => 'YES',
  },
}
```

And if you really know what you are doing, you can use your own template or
start with an empty one which is provided (see `vsftpd.conf(5)`) in order
to have **all** configuration passed in the `directives` hash :

```puppet
class { 'vsftpd':
  template   => 'vsftpd/empty.conf.erb',
  directives => {
    'ftpd_banner'        => 'Upload FTP Server',
    'listen'             => 'YES',
    'tcp_wrappers'       => 'YES',
    'anon_upload_enable' => 'YES',
    'dirlist_enable'     => 'NO',
    'download_enable'    => 'NO',
  },
}
```

