# puppet-npd6

## Overview

Install, configure and enable the Neighbor Proxy Daemon for IPv6.

* `npd6` : Main class

## Example

    class { 'npd6':
      prefix    => '2001:db8:2:60a6:',
      interface => 'br0',
    }

