Custom modules for Puppet, made for Red Hat Enterprise Linux and CentOS
=======================================================================

Overview
--------

The modules present here are either self-contained or depend exclusively on
other modules present here, detailed in each module's Modulefile.

The modules should all be very easy to understand and reuse. See each module's
README file for more information, as well as the auto-generated documentation.

One of the goal is to only perform the repetitive and generic parts, leaving
all specificties outside of modules, yet providing means to inteface them
cleanly. A good example would be the ISC BIND DNS server, for which zone files
installed with the provided definition automatically reload named when changed.

Most of these modules can be downloaded from the Puppet Forge here :
http://forge.puppetlabs.com/thias

The stable modules are under 'modules' and are all git sub-modules of other
git repositories. The modules which are still work in progress are under 'modules-wip'. Pull requests are welcome!

Support
-------

More generic puppet documentation can be found at http://docs.puppetlabs.com/

Documentation for the modules can be automatically generated (see the gendoc
script) and an online snapshot found here :
http://dl.marmotte.net/puppet/doc/

The latest source for these modules can be found at https://github.com/thias

Copyright (c) 2011-2013 Matthias Saou - http://matthias.saou.eu/

