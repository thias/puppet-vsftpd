class vsftpd::params {
    $vsftpd_conf_file = undef

    case $::osfamily {
        'Debian': {
            $vsftpd_conf_file = '/etc/vsftpd.conf'
        }

        'RedHat', 'Amazon': {
            $vsftpd_conf_file = '/etc/vsftpd/vsftpd.conf'
        }
        
        default: { fail("${::operatingsystem} is not supported by ${module_name}") }
    }
}
