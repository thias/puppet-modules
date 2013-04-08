# = Class: geoip::conf
#
# This class configures GeoIP.conf with your credentials provided by MaxMind,
# in order to have the `geoipupdate` program automatically download and
# install the latest GeoIP databases.
#
# == Parameters
#
# [* userid *]
#   UserId provided by MaxMind for your account.
#   Default: none
# [* licensekey *]
#   LicenseKey provided by MaxMind for your account.
#   Default: none
# [* productids *]
#   String list of Product Ids geoipupdate should download.
#   Default: 106
#
# == Examples
#
#     class { 'geoip::conf':
#       userid     => '12345',
#       licensekey => 'abcdefghijklmnop',
#       productids => '106 133',
#     }
#
# == Author
#
# Matthias Saou <matthias@saou.eu>
#
class geoip::conf (
  $userid,
  $licensekey,
  $productids = '106',
  $ensure = 'present'
) {

  if $ensure == 'present' {
    include geoip::common
  }

  file { '/etc/GeoIP.conf':
    owner   => 'root',
    group   => 'root',
    # We typically don't want anyone to see the LicenseKey
    mode    => '0600',
    content => template('geoip/GeoIP.conf.erb'),
    ensure  => $ensure,
  }

}

