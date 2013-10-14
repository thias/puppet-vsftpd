# puppet-vsftpd

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

