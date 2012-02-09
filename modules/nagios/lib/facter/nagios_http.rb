# Create custom nagios_httpd_<exename> facts for each daemon found
# + create a main nagios_httpd fact if one or more is present

httpd = [
    "/usr/sbin/httpd",
    "/usr/sbin/nginx",
    "/usr/sbin/lighttpd",
]

mainfact = false
httpd.each do |filename|
    if FileTest.exists?(filename)
        # Create a specific nagios_httpd_<exename> fact
        Facter.add("nagios_httpd_" + filename[/[^\/]+$/]) do
            setcode do
                "true"
            end
        end
        mainfact = true
    end
end
if mainfact == true
    Facter.add("nagios_httpd") do
        setcode do
            "true"
        end
    end
end

