Apache_httpd {
    extendedstatus => 'On',
    serveradmin    => 'root@mydomain.example.com',
}
apache_httpd { 'worker':
    ssl             => true,
    modules         => [],
    welcome         => false,
    serversignature => 'Off',
}

