# We need the service to exist
include nginx
nginx::file { 'test.conf':
    # Bogus, we just need a file we have access to and which doesn't need
    # a bunch of variables to be used as a template.
    content => template('nginx/nginx.conf.orig'),
}

# Copy/pasted from the README
  include nginx
  $listen_http = [ '127.0.0.1:80', '192.168.0.12:80' ]
  nginx::file { 'www.example.com.conf':
      content => inline_template('# Sample configuration file
  server {
  <% listen_http.each do |listen_line| -%>
      listen <%= listen_line %>;
  <% end -%>
      server_name www.example.com;
      root /var/www/www.example.com;
  }
  '),
  }
