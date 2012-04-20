Apache_httpd {
    extendedstatus => 'On',
    serveradmin    => 'root@mydomain.example.com',
}
apache_httpd { 'worker':
    ssl             => true,
    modules         => [],
    welcome         => false,
    listen          => [ '80', '443' ],
    namevirtualhost => '*:80',
    serversignature => 'Off',
}

