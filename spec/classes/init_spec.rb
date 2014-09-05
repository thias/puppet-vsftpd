require 'spec_helper'

describe 'vsftpd', :type => 'class' do

  platforms      = [ 'RedHat', 'CentOS', 'Amazon', 'Debian', 'Ubuntu' ]
  userlist_users = [ 'root', 'bin', 'daemon', 'nobody' ]
  directives     = {
    'accept_timeout'  => 120,
    'connect_timeout' => 120,
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |value|
      context "#{value}" do
        let(:facts) { { :operatingsystem => value } }

        it { should compile.with_all_deps }

        it { should contain_class('vsftpd') }

        it {
          should contain_package('vsftpd_package').with({
            'ensure' => 'installed',
          })
        }

        it {
          should contain_service('vsftpd_service').with({
            'ensure'    => 'running',
            'enable'    => true,
            'hasstatus' => true,
            'require'   => 'Package[vsftpd_package]',
          })
        }

        it {
          should contain_file('vsftpd_conf').with({
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'require' => 'Package[vsftpd_package]',
            'notify'  => 'Service[vsftpd_service]',
          })
        }

        it { should_not contain_file('vsftpd_conf').with_content(/^userlist_file=\/etc\/vsftpd\/user_list$/) }
      end
    end
  end

  describe 'with manage_userlist_file parameter set' do
    describe 'to true' do
      context 'and userlist_users parameter set to an array' do
        let(:params) { {
          :userlist_enable      => 'YES',
          :manage_userlist_file => true,
          :userlist_users       => userlist_users,
        } }
        let(:facts) { { :operatingsystem => 'RedHat' } }

        it { should contain_file('vsftpd_conf').with_content(/^userlist_file=\/etc\/vsftpd\/user_list$/) }

        it {
          should contain_file('userlist_file').with({
            'path'    => '/etc/vsftpd/user_list',
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'require' => 'Package[vsftpd_package]',
          })
        }

        it {
          should contain_file('ftpusers').with({
            'path'    => '/etc/vsftpd/ftpusers',
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'require' => 'Package[vsftpd_package]',
          })
        }

        it { should contain_file('userlist_file').with_content(/^root$/) }
        it { should contain_file('userlist_file').with_content(/^bin$/) }
        it { should contain_file('userlist_file').with_content(/^daemon$/) }
        it { should contain_file('userlist_file').with_content(/^nobody$/) }
      end

      context 'and userlist_users parameter set to something else than a string' do
        let(:params) { {
          :userlist_enable      => 'YES',
          :manage_userlist_file => true,
          :userlist_users       => false,
        } }
        let(:facts) { { :operatingsystem => 'RedHat' } }

        it {
          expect {
            should contain_class('vsftpd')
          }.to raise_error(Puppet::Error,/vsftpd::userlist_users must be a string and an array. Detected type is <boolean>/)
        }
      end
    end

    describe 'to false' do
      context 'and userlist_users parameter set to an array' do
        let(:params) { {
          :userlist_enable      => 'YES',
          :manage_userlist_file => false,
          :userlist_users       => userlist_users,
        } }
        let(:facts) { { :operatingsystem => 'RedHat' } }

        it { should contain_file('vsftpd_conf').with_content(/^userlist_file=\/etc\/vsftpd\/user_list$/) }

        it {
          should_not contain_file('userlist_file').with({
            'path'    => '/etc/vsftpd/user_list',
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'require' => 'Package[vsftpd_package]',
          })
        }

        it {
          should_not contain_file('ftpusers').with({
            'path'    => '/etc/vsftpd/ftpusers',
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'require' => 'Package[vsftpd_package]',
          })
        }
      end
    end
  end

  describe 'with directives parameter set' do
    let(:params) { {
      :directives => directives,
    } }
    let(:facts) { { :operatingsystem => 'RedHat' } }

    it { should contain_file('vsftpd_conf').with_content(/^accept_timeout=120$/) }
    it { should contain_file('vsftpd_conf').with_content(/^connect_timeout=120$/) }
  end
end
