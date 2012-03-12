# Create custom "puppetmaster" boolean fact

if File.exist? "/etc/puppet/puppetmaster.conf"
    Facter.add("puppetmaster") do
        setcode do
            "true"
        end
    end
end

