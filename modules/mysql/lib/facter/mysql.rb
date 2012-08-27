ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
mysqlexists = system "which mysql > /dev/null 2>&1"
if $?.exitstatus == 0
    # those facts will only be present when mysql exists
    Facter.add("mysql_exists") do
        setcode do
            "true"
        end
    end

    mysqldexists = system "which mysqld_safe > /dev/null 2>&1"
    if $?.exitstatus == 0
        # those facts will only be present when mysqld exists
        Facter.add("mysqld_exists") do
            setcode do
                "true"
            end
        end

        if FileTest.exists?("/root/backup/MySQL")
            Facter.add("mysql_has_backup") do
                setcode do
                    "true"
                end
            end
        end

        Facter.add("mysql_server_id") do
            setcode do
                begin
                    Facter.private_ipaddress
                rescue
                    Facter.loadfacts()
                end
                # Take the 3rd and the 4th octet of the ip address and add padding zeroes to the 4th until it is 3 characters long
                begin
                    Facter.value('private_ipaddress').split(".")[2] + "%03d" % Facter.value('private_ipaddress').split(".")[3]
                rescue
                    # in case private_ipaddress does not exist do not return anything
                end
            end
        end
        
        # The version number is extracted from mysql_client to avoid to connect to mysql_server, because if that one is shut down then we won't get it
        Facter.add("mysql_version") do
            setcode do
                %x{mysql --version}.split(" ")[4].chop
            end
        end

        Facter.add("mysql_version_major") do
            setcode do
                %x{mysql --version}.split(" ")[4].split(".")[0]
            end
        end

        if FileTest.exists?("/var/lib/mysql/.mysql_is_slave")
            Facter.add("mysql_is_slave") do
                setcode do
                    File.read("/var/lib/mysql/.mysql_is_slave")
                end
            end
        end

        if FileTest.exists?("/var/lib/mysql/.mysql_is_master")
            Facter.add("mysql_is_master") do
                setcode do
                    File.read("/var/lib/mysql/.mysql_is_master")
                end
            end
        end

    end
end

