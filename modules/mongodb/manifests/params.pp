# Class: mongodb::params
#
# Parameters for and from the mongodb module.
#
# Parameters :
#  none
#
# Sample Usage :
#  include mongodb::params
#
class mongodb::params {
    # The easy bunch
    $service = 'mongod'
    $conffile = '/etc/mongodb.conf'
    # package
    case $::operatingsystem {
        'Gentoo': { $package = 'dev-db/mongodb' }
         default: { $package = 'mongodb-server' }
    }
  
}
