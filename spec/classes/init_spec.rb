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
  ['RedHat',
  ].each do |operatingsystem|
    context "with default params changed on operatingsystem #{operatingsystem}" do
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
end
