require 'spec_helper'

describe 'vsftpd' do
  config_dir = {
    'RedHat'  => '/etc/vsftpd/vsftpd.conf',
    'CentOS'  => '/etc/vsftpd/vsftpd.conf',
    'Amazon'  => '/etc/vsftpd/vsftpd.conf',
    'Fedora'  => '/etc/vsftpd/vsftpd.conf',
    'Debian'  => '/etc/vsftpd.conf',
    'Ubuntu'  => '/etc/vsftpd.conf',
  }
  ['RedHat', 'CentOS', 'Amazon', 'Debian', 'Ubuntu', 'Fedora',
  ].each do |operatingsystem|
    context "with default params on operatingsystem #{operatingsystem}" do
          let :facts do
            {
              :kernel            => 'Linux',
              :operatingsystem   => operatingsystem,
            }
          end
          it { should compile.with_all_deps }

          it { should contain_class('vsftpd')}

          it {
            should contain_package('vsftpd').with({
              'ensure' => 'installed',
            })
          }
          it {
            should contain_file(config_dir[operatingsystem]).with({
              'path' => config_dir[operatingsystem],
              'content' => File.read(fixtures('vsftpd_with_default_params'))
            })
        }
    end
  end
  ['RedHat', 'CentOS', 'Amazon', 'Debian', 'Ubuntu', 'Fedora',
  ].each do |operatingsystem|
    context "with default params changed in hiera on operatingsystem #{operatingsystem}" do
          let :facts do
            {
              :kernel            => 'Linux',
              :operatingsystem   => operatingsystem,
              :specific          => 'vsftpd_without_default_params',
            }
          end
          it { should compile.with_all_deps }

          it { should contain_class('vsftpd')}

          it {
            should contain_package('vsftpd').with({
              'ensure' => 'installed',
            })
          }
          it {
            should contain_file(config_dir[operatingsystem]).with({
              'path' => config_dir[operatingsystem],
              'content' => File.read(fixtures('vsftpd_without_default_params'))
            })
        }
    end
  end
  context "with parameter changed from default value" do
    fName = '/etc/vsftpd/vsftpd.conf'
    parameters = {
      'anon_world_readable_only' => {'default' => 'YES', 'set' => 'NO'},
      'background'               => {'default' => 'YES', 'set' => 'NO'},
      'check_shell'              => {'default' => 'YES', 'set' => 'NO'},
      'chmod_enable'             => {'default' => 'YES', 'set' => 'NO'},
      'deny_email_enable'        => {'default' => 'NO', 'set' => 'YES'},
      'dirlist_enable'           => {'default' => 'YES', 'set' => 'NO'},
      'download_enable'          => {'default' => 'YES', 'set' => 'NO'},
      'dual_log_enable'          => {'default' => 'NO', 'set' => 'YES'},
      'force_dot_files'          => {'default' => 'NO', 'set' => 'YES'},
      'force_anon_data_ssl'      => {'default' => 'NO', 'set' => 'YES'},
      'force_anon_logins_ssl'    => {'default' => 'NO', 'set' => 'YES'},
      'force_local_data_ssl'     => {'default' => 'YES', 'set' => 'NO'},
      'force_local_logins_ssl'   => {'default' => 'YES', 'set' => 'NO'},
      'guest_enable'             => {'default' => 'NO', 'set' => 'YES'},
      'listen_ipv6'              => {'default' => 'NO', 'set' => 'YES'},
      'lock_upload_files'        => {'default' => 'NO', 'set' => 'YES'},
      'log_ftp_protocol'         => {'default' => 'NO', 'set' => 'YES'},
      'mdtm_write'               => {'default' => 'YES', 'set' => 'NO'},
      'no_anon_password'         => {'default' => 'NO', 'set' => 'YES'},
      'no_log_lock'              => {'default' => 'NO', 'set' => 'YES'},
      'one_process_model'        => {'default' => 'NO', 'set' => 'YES'},
      'passwd_chroot_enable'     => {'default' => 'NO', 'set' => 'YES'},
      'pasv_addr_resolve'        => {'default' => 'NO', 'set' => 'YES'},
      'pasv_enable'              => {'default' => 'YES', 'set' => 'NO'},
      'pasv_promiscuous'         => {'default' => 'NO', 'set' => 'YES'},
      'port_enable'              => {'default' => 'YES', 'set' => 'NO'},
      'port_promiscuous'         => {'default' => 'NO', 'set' => 'YES'},
      'reverse_lookup_enable'    => {'default' => 'YES', 'set' => 'NO'},
      'run_as_launching_user'    => {'default' => 'NO', 'set' => 'YES'},
      'secure_email_list_enable' => {'default' => 'NO', 'set' => 'YES'},
      'session_support'          => {'default' => 'NO', 'set' => 'YES'},
      'ssl_enable'               => {'default' => 'NO', 'set' => 'YES'},
      'ssl_sslv2'                => {'default' => 'NO', 'set' => 'YES'},
      'ssl_sslv3'                => {'default' => 'NO', 'set' => 'YES'},
      'ssl_tlsv1'                => {'default' => 'YES', 'set' => 'NO'},
      'syslog_enable'            => {'default' => 'NO', 'set' => 'YES'},
      'tilde_user_enable'        => {'default' => 'NO', 'set' => 'YES'},
      'use_localtime'            => {'default' => 'NO', 'set' => 'YES'},
      'use_sendfile'             => {'default' => 'YES', 'set' => 'NO'},
      'userlist_log'             => {'default' => 'NO', 'set' => 'YES'},
      'virtual_use_local_privs'  => {'default' => 'NO', 'set' => 'YES'},
      'accept_timeout'           => {'default' => '60', 'set' => '30'},
      'anon_max_rate'            => {'default' => '0', 'set' => '1'},
      'anon_umask'               => {'default' => '077', 'set' => '022'},
      'connect_timeout'          => {'default' => '60', 'set' => '30'},
      'delay_failed_login'       => {'default' => '1', 'set' => '2'},
      'delay_successful_login'   => {'default' => '0', 'set' => '1'},
      'file_open_mode'           => {'default' => '0666', 'set' => '0777'},
      'ftp_data_port'            => {'default' => '20', 'set' => '21'},
      'local_max_rate'           => {'default' => '0', 'set' => '1'},
      'max_login_fails'          => {'default' => '3', 'set' => '1'},
      'trans_chunk_size'         => {'default' => '0', 'set' => '1'},
      'anon_root'                => {'default' => 'undef', 'set' => '/root/'},
      'banned_email_file'        => {'default' => '/etc/vsftpd/banned_emails', 'set' => '/banned_emails'},
      'cmds_allowed'             => {'default' => 'undef', 'set' => 'PASV,RETR,QUIT'},
      'deny_file'                => {'default' => 'undef', 'set' => '/deny_these_guys'},
      'dsa_cert_file'            => {'default' => 'undef', 'set' => '/ftp_certificates/dsa.cert'},
      'dsa_private_key_file'     => {'default' => 'undef', 'set' => '/ftp_certificates/dsa.key'},
      'email_password_file'      => {'default' => '/etc/vsftpd/email_passwords', 'set' => '/email_passwords'},
      'guest_username'           => {'default' => 'ftp', 'set' => 'ftpd'},
      'listen_address'           => {'default' => 'undef', 'set' => '127.0.0.1'},
      'listen_address6'          => {'default' => 'undef', 'set' => '::1'},
      'local_root'               => {'default' => 'undef', 'set' => '/local/root'},
      'message_file'             => {'default' => '.message', 'set' => '.message_file'},
      'pasv_address'             => {'default' => 'undef', 'set' => '127.0.0.1'},
      'rsa_cert_file'            => {'default' => '/usr/share/ssl/certs/vsftpd.pem', 'set' => '/ftp_certificates/rsa.cert'},
      'rsa_private_key_file'     => {'default' => 'undef', 'set' => '/ftp_certificates/rsa.key'},
      'secure_chroot_dir'        => {'default' => '/usr/share/empty', 'set' => '/dev/null'},
      'ssl_ciphers'              => {'default' => 'DES-CBC3-SHA', 'set' => 'EDH-RSA-DES-CBC3-SHA'},
      'user_config_dir'          => {'default' => 'undef', 'set' => '/etc/vsftpd_user_conf/chris'},
      'user_sub_token'           => {'default' => 'undef', 'set' => '$USER'},
      'userlist_file'            => {'default' => '/etc/vsftpd/user_list', 'set' => '/user_list'},
      'vsftpd_log_file'          => {'default' => '/var/log/vsftpd.log', 'set' => '/var/log/ftp_logs.log'},
    }.each do |parameter, values|
      context "#{parameter} set to #{values['set']}" do
        let :params do
          {
            :"#{parameter}" => values['set']
          }
        end

        set = "#{Regexp.escape(values['set'])}"
        default = "#{Regexp.escape(values['default'])}"

        it { should contain_file(fName).with_content(/^#{parameter}=#{set}$/) }
        it { should contain_file(fName).without_content(/^[#]?#{parameter}=#{default}$/) }
      end
    end
  end
end
