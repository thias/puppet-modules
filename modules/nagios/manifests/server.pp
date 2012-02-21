class nagios::server (
    # For the tag of the stored configuration to realize
    $nagios_server = 'default',
    $apache_httpd = true,
    $apache_httpd_ssl = true,
    $apache_httpd_modules = [
        'auth_basic',
        'authn_file',
        'authz_host',
        'authz_user',
        'env',
        'mime',
        'negotiation',
        'dir',
        'alias',
        'rewrite',
        'cgi',
    ],
    $apache_httpd_conf_source = 'puppet:///modules/nagios/apache-httpd/httpd-nagios.conf',
    $apache_httpd_htpasswd_source = 'puppet:///modules/nagios/apache-httpd/htpasswd',
    $php = true,
    $php_apc = true,
    # cgi.cfg
    $cgi_authorized_for_system_information = 'nagiosadmin',
    $cgi_authorized_for_configuration_information = 'nagiosadmin',
    $cgi_authorized_for_system_commands = 'nagiosadmin',
    $cgi_authorized_for_all_services = 'nagiosadmin',
    $cgi_authorized_for_all_hosts = 'nagiosadmin',
    $cgi_authorized_for_all_service_commands = 'nagiosadmin',
    $cgi_authorized_for_all_host_commands = 'nagiosadmin',
    $cgi_default_statusmap_layout = '5',
    # nagios.cfg
    $cfg_file = [
        # Original files - only reuse the templates as-is
#        '/etc/nagios/objects/commands.cfg',
#        '/etc/nagios/objects/contacts.cfg',
#        '/etc/nagios/objects/timeperiods.cfg',
        '/etc/nagios/objects/templates.cfg',
        # Where puppet managed types are
        '/etc/nagios/nagios_command.cfg',
        '/etc/nagios/nagios_contact.cfg',
        '/etc/nagios/nagios_contactgroup.cfg',
        '/etc/nagios/nagios_host.cfg',
#        '/etc/nagios/nagios_hostdependency.cfg',
        '/etc/nagios/nagios_hostgroup.cfg',
        '/etc/nagios/nagios_service.cfg',
        '/etc/nagios/nagios_timeperiod.cfg',
    ],
    $cfg_dir = [],
    $process_performance_data = '0',
    $host_perfdata_command = false,
    $service_perfdata_command = false,
    $service_perfdata_file = false,
    $service_perfdata_file_template = '[SERVICEPERFDATA]\t$TIMET$\t$HOSTNAME$\t$SERVICEDESC$\t$SERVICEEXECUTIONTIME$\t$SERVICELATENCY$\t$SERVICEOUTPUT$\t$SERVICEPERFDATA$',
    $service_perfdata_file_mode = 'a',
    $service_perfdata_file_processing_interval = '0',
    $service_perfdata_file_processing_command = false,
    $date_format = 'iso8601',
    $admin_email = 'root@localhost',
    $admin_pager = 'pagenagios@localhost',
    # private/resource.cfg for $USERx$ macros (from 1 to 32)
    $user = {
        '1' => '/usr/libexec/nagios/plugins',
    },
    # Options for all nrpe-based checks
    $nrpe_options = '-t 15',
    # Contacts and Contact Groups
    $admins_members = 'nagiosadmin',
    # Others
    $notify_host_by_email_command_line = '/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$',
    $notify_service_by_email_command_line = '/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$" | /bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
    $timeperiod_workhours = '09:00-17:00',
    $plugin_dir = '/usr/libexec/nagios/plugins',
    $plugin_nginx = false,
    $selinux = true
) {

    # Full nrpe command to run, with default options
    $nrpe = "\$USER1\$/check_nrpe -H \$HOSTADDRESS\$ ${nrpe_options}"

    # Plugin packages required on the server side
    package { [
        'nagios',
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-http',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
        'nagios-plugins-udp',
    ]:
        ensure => installed,
    }

    # Custom plugin scripts required on the server
    if $plugin_nginx {
        file { "${plugin_dir}/check_nginx":
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            content => template('nagios/plugins/check_nginx'),
            ensure  => $ensure,
        }
    } else {
        file { "${plugin_dir}/check_nginx":
            ensure => absent,
        }
    }

    # Other packages
    package { [
        'mailx',            # For the default email notifications to work
    ]:
        ensure => installed,
    }

    service { 'nagios':
        enable    => true,
        ensure    => running,
        # "service nagios status" returns 0 when "nagios is not running" :-(
        hasstatus => false,
        # Don't get fooled by any process with "nagios" in its command line
        pattern   => '/usr/sbin/nagios',
        # Work around files created root:root mode 600 (known issue)
        restart   => '/bin/chgrp nagios /etc/nagios/nagios_*.cfg && /bin/chmod 640 /etc/nagios/nagios_*.cfg && /sbin/service nagios reload',
        require   => Package['nagios'],
    }

    file { '/etc/httpd/conf.d/nagios.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => $apache_httpd_conf_source,
        notify  => Service['httpd'],
        require => Package['nagios'],
    }
    if $apache_httpd_htpasswd_source != false {
        file { '/etc/nagios/.htpasswd':
            owner   => 'root',
            group   => 'apache',
            mode    => '0640',
            source  => $apache_httpd_htpasswd_source,
            require => Package['nagios'],
        }
    }

    if $apache_httpd {
        apache-httpd { 'prefork':
            ssl       => $apache_httpd_ssl,
            modules   => $apache_httpd_modules,
            keepalive => 'On',
        }
    }
        
    if $php {
        class { 'php::mod_php5': inifile => '/etc/httpd/conf/php.ini' }
        php::ini { '/etc/httpd/conf/php.ini':
            require => Package['httpd'],
        }
        if $php_apc {
            php::module { 'pecl-apc': }
        }
    }

    # Configuration files
    file { '/etc/nagios/cgi.cfg':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('nagios/cgi.cfg.erb'),
        # No need to reload the service, changes are applied immediately
        require => Package['nagios'],
    }
    file { '/etc/nagios/nagios.cfg':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('nagios/nagios.cfg.erb'),
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    file { '/etc/nagios/private/resource.cfg':
        owner   => 'root',
        group   => 'nagios',
        mode    => '0640',
        content => template('nagios/resource.cfg.erb'),
        notify  => Service['nagios'],
        require => Package['nagios'],
    }

    # Realize all nagios related configuration for this server
    # Automatically reload nagios for relevant configuration changes
    Nagios_host <<| tag == "nagios-${nagios_server}" |>> {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_hostdependency <<| tag == "nagios-${nagios_server}" |>> {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_service <<| tag == "nagios-${nagios_server}" |>> {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_contact {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_contactgroup {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_timeperiod {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
    Nagios_hostgroup {
        notify  => Service['nagios'],
        require => Package['nagios'],
    }

    # Works great, but only if the "target" is the default (known limitation)
    resources { [
        'nagios_command',
        'nagios_contact',
        'nagios_contactgroup',
        'nagios_host',
        'nagios_hostdependency',
        'nagios_hostgroup',
        'nagios_service',
        'nagios_timeperiod',
    ]:
        purge => true,
    }

    # Work around a puppet bug where created files are 600 root:root
    file { [
        '/etc/nagios/nagios_command.cfg',
        '/etc/nagios/nagios_contact.cfg',
        '/etc/nagios/nagios_contactgroup.cfg',
        '/etc/nagios/nagios_host.cfg',
        '/etc/nagios/nagios_hostdependency.cfg',
        '/etc/nagios/nagios_hostgroup.cfg',
        '/etc/nagios/nagios_service.cfg',
        '/etc/nagios/nagios_timeperiod.cfg',
    ]:
        owner => 'root',
        group => 'nagios',
        mode  => '0640',
    }

    # Nagios commands
    # Taken from commands.cfg
    nagios_command { 'notify-host-by-email':
        command_line => $notify_host_by_email_command_line,
    }
    nagios_command { 'notify-service-by-email':
        command_line => $notify_service_by_email_command_line,
    }
    nagios_command { 'check-host-alive':
        command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5',
    }
    nagios_command { 'check_ftp':
        command_line => '$USER1$/check_ftp -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_hpjd':
        command_line => '$USER1$/check_hpjd -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_snmp':
        command_line => '$USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_http':
        command_line => '$USER1$/check_http -I $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_ssh':
        command_line => '$USER1$/check_ssh $ARG1$ $HOSTADDRESS$',
    }
    nagios_command { 'check_dhcp':
        command_line => '$USER1$/check_dhcp $ARG1$',
    }
    nagios_command { 'check_ping':
        command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5',
    }
    nagios_command { 'check_pop':
        command_line => '$USER1$/check_pop -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_imap':
        command_line => '$USER1$/check_imap -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_smtp':
        command_line => '$USER1$/check_smtp -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_tcp':
        command_line => '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$',
    }
    nagios_command { 'check_udp':
        command_line => '$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$',
    }
    nagios_command { 'check_nt':
        command_line => '$USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$',
    }
    # Custom commands
    nagios_command { 'check_ping_addr':
        command_line => '$USER1$/check_ping -H $ARG1$ -w $ARG2$ -c $ARG3$ -p 5',
    }
    nagios_command { 'check_dns':
        command_line => '$USER1$/check_dns -H $HOSTADDRESS$ $ARG1$',
    }
    nagios_command { 'check_dns_addr':
        command_line => '$USER1$/check_dns -H $ARG1$ $ARG2$',
    }
    nagios_command { 'check_http_url':
        command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ $ARG3$',
    }
    nagios_command { 'check_proxy':
        command_line => '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$',
    }
    nagios_command { 'check_nginx':
        command_line => '$USER1$/check_nginx $ARG1$',
    }
    # Custom NRPE-based commands
    nagios_command { 'check_nrpe_users':
        command_line => "${nrpe} -c check_users",
    }
    nagios_command { 'check_nrpe_load':
        command_line => "${nrpe} -c check_load",
    }
    nagios_command { 'check_nrpe_zombie_procs':
        command_line => "${nrpe} -c check_zombie_procs",
    }
    nagios_command { 'check_nrpe_total_procs':
        command_line => "${nrpe} -c check_total_procs",
    }
    nagios_command { 'check_nrpe_swap':
        command_line => "${nrpe} -c check_swap",
    }
    nagios_command { 'check_nrpe_disk':
        command_line => "${nrpe} -c check_disk",
    }
    nagios_command { 'check_nrpe_proc':
        command_line => "${nrpe} -c check_proc",
    }
    nagios_command { 'check_nrpe_ntp_time':
        command_line => "${nrpe} -c check_ntp_time",
    }
    # Custom NRPE-based commands using custom plugins
    nagios_command { 'check_nrpe_ram':
        command_line => "${nrpe} -c check_ram",
    }
    nagios_command { 'check_nrpe_cpu':
        command_line => "${nrpe} -c check_cpu",
    }
    nagios_command { 'check_nrpe_membase':
        command_line => "${nrpe} -c check_membase",
    }
    nagios_command { 'check_nrpe_moxi':
        command_line => "${nrpe} -c check_moxi",
    }
    # Custom NRPE-based commands using custom plugins, conditionally enabled
    nagios_command { 'check_nrpe_megaraid_sas':
        command_line => "${nrpe} -c check_megaraid_sas",
    }
    nagios_command { 'check_nrpe_mptsas':
        command_line => "${nrpe} -c check_mptsas",
    }
    nagios_command { 'check_nrpe_jobs_status':
        command_line => "${nrpe} -c check_jobs_status",
    }
    # TODO: sort these
    nagios_command { 'check_nrpe_conntrack':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_conntrack',
    }
    nagios_command { 'check_nrpe_sslcerts':
        command_line => '$USER1$/check_nrpe -t 25 -H $HOSTADDRESS$ -c check_sslcerts',
    }
    nagios_command { 'check_nrpe_mysql':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_mysql',
    }
    nagios_command { 'check_nrpe_mysql_health':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_mysql_health_$ARG1$',
    }
    nagios_command { 'check_nrpe_mysqlbackup':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_mysqlbackup',
    }
    nagios_command { 'check_nrpe_mysql_slave':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_mysql_slave',
    }
    nagios_command { 'check_nrpe_mysql_query':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_mysql_query',
    }
    nagios_command { 'check_nrpe_oracle_health':
        command_line => '$USER1$/check_nrpe -t 200 -H $HOSTADDRESS$ -c check_oracle_health_$ARG1$',
    }
    nagios_command { 'check_nrpe_megaraid':
        command_line => '$USER1$/check_nrpe -t 120 -H $HOSTADDRESS$ -c check_megaraid',
    }
    nagios_command { 'check_nrpe_perc':
        command_line => '$USER1$/check_nrpe -t 25 -H $HOSTADDRESS$ -c check_perc',
    }
    nagios_command { 'check_nrpe_cerc':
        command_line => '$USER1$/check_nrpe -t 25 -H $HOSTADDRESS$ -c check_cerc',
    }
    nagios_command { 'check_nrpe_lsi':
        command_line => '$USER1$/check_nrpe -t 25 -H $HOSTADDRESS$ -c check_lsi',
    }
    nagios_command { 'check_nrpe_mdraid':
        command_line => '$USER1$/check_nrpe -t 25 -H $HOSTADDRESS$ -c check_mdraid',
    }
    nagios_command { 'check_ldap':
        command_line => '$USER1$/check_ldap -H $HOSTADDRESS$ -D $ARG1$ -P $ARG2$ -b $ARG3$',
    }
    nagios_command { 'check_ldaps':
        command_line => '$USER1$/check_ldaps -H $HOSTNAME$ -D $ARG1$ -P $ARG2$ -b $ARG3$',
    }
    nagios_command { 'check_nrpe_ldapdb':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_ldapdb',
    }
    nagios_command { 'check_nrpe_ldaprep':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_ldaprep',
    }
    nagios_command { 'check_nrpe_xen':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_xen',
    }
    nagios_command { 'check_nrpe_radius':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_radius',
    }
    nagios_command { 'check_nrpe_squale':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_squale',
    }
    nagios_command { 'check_nrpe_search':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_search',
    }
    nagios_command { 'check_nrpe_gdns':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_gdns',
    }
    nagios_command { 'check_nrpe_bonding':
        command_line => '$USER1$/check_nrpe -t 15 -H $HOSTADDRESS$ -c check_bonding',
    }

    # Nagios contacts and contactgroups
    # Taken from contacts.cfg
    nagios_contact { 'nagiosadmin':
        use   => 'generic-contact',
        alias => 'Nagios Admin',
        email => $admin_email,
    }
    nagios_contactgroup { 'admins':
        alias   => 'Nagios Administrators',
        members => $admins_members,
    }

    # Nagios timeperiods
    # Taken from timeperiods.cfg
    nagios_timeperiod { '24x7':
        alias       => '24 Hours A Day, 7 Days A Week',
        monday      => '00:00-24:00',
        tuesday     => '00:00-24:00',
        wednesday   => '00:00-24:00',
        thursday    => '00:00-24:00',
        friday      => '00:00-24:00',
        saturday    => '00:00-24:00',
        sunday      => '00:00-24:00',
    }
    nagios_timeperiod { 'workhours':
        alias       => 'Normal Work Hours',
        monday      => $timeperiod_workhours,
        tuesday     => $timeperiod_workhours,
        wednesday   => $timeperiod_workhours,
        thursday    => $timeperiod_workhours,
        friday      => $timeperiod_workhours,
    }

    # With selinux, adjustements are needed for nagiosgraph
    if $selinux and $::selinux_enforced {
        selinux::audit2allow { 'nagios':
            source => 'puppet:///modules/nagios/messages.nagios',
        }
    }

    # TODO : Clean

    # Custom icons
#    file { '/usr/share/nagios/html/images/logos':
#        ensure  => directory,
#        recurse => true,
#        owner   => 'root',
#        group   => 'root',
#        source  => 'puppet:///modules/nagios/usr/share/nagios/html/images/logos',
#    }

}

