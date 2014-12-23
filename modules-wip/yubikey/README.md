# puppet-yubikey

## Overview

Install, enable and configure YubiKey related services.

The implementation is Red Hat Enterprise Linux (RHEL) specific because of the
package naming and file locations.

Required modules for the KSM and Validation servers :
* `puppetlabs-mysql`
* `thias-apache_httpd`
* `thias-php`

* `yubikey::ksm` : Class to install and enable the Key Storage Module server.
* `yubikey::val` : Class to install and enable the Valisation server.

## Examples

Hiera data :

---
yubikey::params::mysql_config_hash:
  root_password: 'Jzfbtyu1_0'
yubikey::params::mysql_settings:
  mysqld:
    skip-networking: true
    skip-innodb: true

You will need to manually apply the database schemas.
For ksm :

    mysql ykksm < /usr/share/doc/yubikey-ksm-*/ykksm-db.sql

For val :

    mysql ykval < /usr/share/doc/yubikey-val-*/ykval-db.sql

Then you will need to populate the two databases, see the main YubiKey
documentation for how to do that. Here is a quick example (as of 1.5) :

    gpg --gen-key
    # Use your own key as the recipient (from above, and the outpout)
    ykksm-gen-keys --urandom 0 9 | gpg -a -e -s > keys.gpg
    ykksm-import --verbose --database 'DBI:mysql:dbname=ykksm' --db-user root --db-passwd Jzfbtyu1_0 < keys.gpg
    # For the ykval database, use the following awk script
    { print "INSERT INTO yubikeys VALUES (1, NOW()+0, NOW()+0, '" $2 "', 0, 0, 0, 0, '', '');" }
    awk -F , -f script.awk keys.txt
    INSERT INTO clients VALUES (1234,1,NOW()+0,'',NULL,NULL,NULL);

Finally, for a single node ksm+val :

    class { 'yubikey::ksm': db_password => 'JenuvSetCo4-F' }
    class { 'yubikey::val': db_password => 'su8dkUn3chPeech' }

