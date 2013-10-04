# Class: ipa::client
#
# IPA client.
#
# Parameters:
#  $ensure:
#    Whether XYZ should be 'present' or 'absent'. Defaults to 'present'.
#  $other:
#    Optional other. Default: none
#
# Sample Usage :
#  class { 'ipa::client':
#      install_options = '--enable-dns-updates',
#  }
#  ipa-client-install --enable-dns-updates --configure-ssh --mkhomedir
#
class ipa::client (
    $principal       = undef,
    $password        = undef,
    $configure       = false,
    $install_options = ''
) inherits ipa::params {

    package { "${ipa}-client": ensure => installed }

    # TODO: Optional ipa-admintools

    # Build some sort of command-line bit
    if $principal { $opt_principal = " --principal=${principal}" }
    if $password  { $opt_password  = " --password=${password}"   }

    if $configure {
        exec { 'ipa-client-install':
            command => "/usr/sbin/ipa-client-install${opt_principal}${opt_password} --unattended ${install_options}",
            creates => '/etc/ipa/xx',
            require => Package["${ipa}-client"],
        }
    }

}

