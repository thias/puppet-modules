# Proxy PHP requests to the FastCGI backend
location ~ \.php$ {
    # Don't bother PHP if the file doesn't exist, return the built in
    # 404 page (this also avoids "No input file specified" error pages)
    if (!-f $request_filename) { return 404; }
    include       /etc/nginx/fastcgi.conf;
    fastcgi_pass  fpmbackend;
}

