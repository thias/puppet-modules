# = Class: geoip::common
#
# GeoIP configuration used by other classes.
#
class geoip::common {
 
  package { 'GeoIP': ensure => installed }

}

