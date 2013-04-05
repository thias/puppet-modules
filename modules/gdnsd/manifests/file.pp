# Define: gdnsd::file
#
# Install gdnsd configuration files. Typically the main 'config' file, then
# any number of DNS zone files.
#
# Example :
#   gdnsd::file { 'config':
#     content => template('modules/mymodule/gdnsd/config.erb'),
#   }
#   gdnsd::file { 'example.com':
#     source => 'puppet:///modules/mymodule/dns/example.com',
#   }
#
define gdnsd::file (
  $ensure      = undef,
  $source      = undef,
  $source_base = undef,
  $content     = undef
) {

  if $source      { $zone_source = $source }
  if $source_base { $zone_source = "${source_base}${title}" }

  file { "/etc/gdnsd/${title}":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => $zone_source,
    content => $content,
    notify  => Service['gdnsd'],
    # For the parent directory
    require => Package['gdnsd'],
    ensure  => $ensure,
  }

}

