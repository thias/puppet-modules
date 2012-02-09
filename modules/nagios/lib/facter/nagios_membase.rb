# Create custom nagios_membase fact if membase is found

if FileTest.exists?("/opt/membase/bin/mbstats")
    Facter.add("nagios_membase") do
        setcode do
            "true"
        end
    end
end

