# Create custom nagios_hostgroups fact for each nagios_hostgroup found.

files = Dir["/etc/nagios/facter/hostgroup_*.conf"]

if !files.empty?
    hostgroups = files.collect {|filename| filename[/_([^\.]+)\.conf$/, 1] }
    Facter.add("nagios_hostgroups") do
        setcode do
            hostgroups.join(',')
        end
    end
end

