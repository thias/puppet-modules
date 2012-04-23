Apache_httpd::Htpasswd { 
    file => '/etc/httpd/htpasswd'
}
apache_httpd::htpasswd { 
  'user0':
    password => '$apr1$gW9nYXAe$Nc4v5xoPcFhjdVZHFaUNT0';
  'user1':
    password => '$apr1$RNvZVTO9$CyU8OfyVZMbdmx4534ngz0',
    ensure   => absent;
  'user2':
    password => '$apr1$uhx4s3XL$muKjLJNnEIISBrhoyFp241';
}

