# Disable potential XSS attacks... err, make nessus stop complaining :-p
# Use from all VirtualHost sections like follows :
#     Include conf.d/trace.inc

RewriteEngine on
RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
RewriteRule .* - [F]

