# Create custom nagios_moxi fact if moxi is found

if FileTest.exists?("/opt/moxi/bin/moxi")
    Facter.add("nagios_moxi") do
        setcode do
            "true"
        end
    end
end

