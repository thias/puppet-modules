# Class: geoip::file
#
# Install any of the GeoIP database files.
#
# Parameters:
#  $ensure:
#    Whether the file should be 'present' or 'absent'. Defaults to 'present'.
#  $path:
#    Full path where to install the file to. Default: /usr/share/GeoIP
#  $source_path:
#    Puppet path prefix where to find the source file. Mandatory.
#
# Sample Usage :
#  Geoip::File { source_path => 'puppet:///modules/foo/GeoIP' }
#  geoip::file { [ 'GeoIP.dat', 'GeoIPv6.dat' ]: }
#
define geoip::file (
  $ensure      = undef,
  $path        = '/usr/share/GeoIP',
  $source_path
) {

  file { "${path}/${title}":
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    source   => "${source_path}/${title}",
    # Be nice and don't re-read the entire file each run
    # Doesn't work with 2.7.13 on Gentoo at least...
    #checksum => 'mtime',
    ensure   => $ensure,
  }

}

