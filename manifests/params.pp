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

}

