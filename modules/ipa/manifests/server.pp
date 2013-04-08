# Class: ipa::server
#
# IPA server. Note that all of the parameters are only used when initially
# installing and configuring the IPA server instance. If any parameters are
# changed later on, it will not be taken into account.
#
# Sample Usage :
#  class { 'ipa::server':
#      realm_name      => 'EXAMPLE.COM',
#      domain_name     => 'example.com',
#      dm_password     => 'godBechyuemtir',
#      admin_password  => 'KierwirgOrokCyb',
#      install_options => '--ssh-trust-dns --subject="O=Example" --setup-dns --forwarder=8.8.8.8 --forwarder=8.8.4.4 --reverse-zone=1.168.192.in-addr.arpa.',
#  }
#
class ipa::server (
    $realm_name,
    $domain_name,
    $dm_password,
    $admin_password,
    $install_options = '',
    $dns_packages = true
) inherits ipa::params {

    package { "${ipa}-server": ensure => installed }
    if $dns_packages {
        package { [ 'bind', 'bind-dyndb-ldap' ]:
            ensure => installed,
            before => Exec['ipa-server-install'],
        }
    }

    # Initial unattended installation
    exec { 'ipa-server-install':
        command => "/usr/sbin/ipa-server-install -r ${realm_name} -n ${domain_name} -p ${dm_password} -a ${admin_password} --unattended ${install_options} &>/root/ipa-install.log",
        creates => '/var/lib/ipa/sysrestore/sysrestore.state',
        require => Package["${ipa}-server"],
    }

    # This shouldn't be needed...
    service { 'httpd': enable => true, require => Exec['ipa-server-install'] }

}

