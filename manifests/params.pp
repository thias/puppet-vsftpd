# Class: vsftpd::params
#
class vsftpd::params {

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

