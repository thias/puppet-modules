# Define: elasticsearch
#
# Elasticsearch module.
#
# Parameters:
#  $foo:
#    Whether...
#
# Sample Usage :
#  include elasticsearch
#
class elasticsearch (
    # elasticsearch.yml
    $cluster_name = undef,
    $node_name = undef,
    $node_master = undef,
    $node_data = undef,
    $node_rack = undef,
    $node_max_local_storage_nodes = undef,
    $network_bind_host = undef,
    $network_publish_host = undef,
    $network_host = undef,
    $transport_tcp_port = undef,
    $transport_tcp_compress = undef,
    $http_port = undef,
    $http_enabled = undef,
    # sysconfig
    $es_min_mem = undef,
    $es_max_mem = undef
) {

    # Typical main package and service
    package { 'elasticsearch': ensure => installed }
    service { 'elasticsearch':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['elasticsearch'],
    }

    # Configuration files
    file { '/etc/sysconfig/elasticsearch':
        content => template('elasticsearch/sysconfig-elasticsearch.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['elasticsearch'],
    }
    file { '/etc/elasticsearch/elasticsearch.yml':
        content => template('elasticsearch/elasticsearch.yml.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['elasticsearch'],
        require => Package['elasticsearch'],
    }
    # TODO: logging.yml.erb if useful...

}

