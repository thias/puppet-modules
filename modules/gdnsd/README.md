# puppet-gdnsd

## Overview

Install, enable and configure the gdnsd DNS server.

* `gdnsd` : Main class to install, enable and configure the server.
* `gdnsd::file` : Definition to manage configuration and zone files.

## Examples

Install and enable the server (for the ip_nonlocal_bind to work, you will need
the sysctl module) :

    class { 'gdnsd': ip_nonlocal_bind => true }

Configure the server using a template, and install a single zone file :

    gdnsd::file { 'config':
        content => template('modules/mymodule/gdnsd/config.erb'),
    }
    gdnsd::file { 'example.com':
        source => 'puppet:///modules/mymodule/dns/example.com',
    }

For more information, including help and configuration examples, see :
https://github.com/blblack/gdnsd

