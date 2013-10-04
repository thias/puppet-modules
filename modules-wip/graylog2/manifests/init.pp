# Class: graylog2
#
# Graylog2.
#
# Parameters:
#  $...
#    ...
# Sample Usage :
#  include graylog2
#
class graylog2 (
    # /etc/sysconfig/graylog2-server
    $user = undef,
    $options = undef,
    # /etc/graylog2.conf
    $syslog_listen_port = '514',
    $syslog_protocol = 'udp',
    $elasticsearch_url = 'http://localhost:9200/',
    $elasticsearch_index_name = 'graylog2',
    $force_syslog_rdns = 'false',
    $allow_override_syslog_date = 'true',
    $mongodb_useauth = 'true',
    $mongodb_user = 'grayloguser',
    $mongodb_password = '123',
    $mongodb_host = 'localhost',
    $mongodb_replica_set = undef,
    $mongodb_database = 'graylog2',
    $mongodb_port = '27017',
    $mq_batch_size = '4000',
    $mq_poll_freq = '1',
    $mq_max_size = '0',
    $mongodb_max_connections = '100',
    $mongodb_threads_allowed_to_block_multiplier = '5',
    $use_gelf = 'true',
    $gelf_listen_address = '0.0.0.0',
    $gelf_listen_port = '12201',
    $rules_file = undef,
    $amqp_enabled = 'false',
    $amqp_subscribed_queues = 'somequeue1:gelf,somequeue2:gelf,somequeue3:syslog',
    $amqp_host = 'localhost',
    $amqp_port = '5672',
    $amqp_username = 'guest',
    $amqp_password = 'guest',
    $amqp_virtualhost = '/',
    $forwarder_loggly_timeout = '3'
) {

    # Package and service
    package { 'graylog2-server': ensure => installed }
    service { 'graylog2-server':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['graylog2-server'],
    }

    # Configuration files
    file { '/etc/graylog2.conf':
        content => template('graylog2/graylog2.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['graylog2-server'],
    }
    file { '/etc/sysconfig/graylog2-server':
        content => template('graylog2/graylog2-server.sysconfig.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['graylog2-server'],
    }

}

