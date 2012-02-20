# Create custom nagios_contactgroups fact for each nagios_contactgroup found.

files = Dir["/etc/nagios/facter/contactgroup_*.conf"]

if !files.empty?
    contactgroups = files.collect {|filename| filename[/_([^\.]+)\.conf$/, 1] }
    Facter.add("nagios_contactgroups") do
        setcode do
            contactgroups.join(',')
        end
    end
end

