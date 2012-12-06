# Custom f3backup_* facts to tweak backup defaults.
if FileTest.exists?('/etc/f3backup/facter')
    Dir.entries('/etc/f3backup/facter/').each do |file|
        if file[-5..-1] ==  '.conf'
            Facter.add('f3backup_' + file[0..-6]) do
                setcode do
                    File.read("/etc/f3backup/facter/" + file).chomp
                end
            end
        end
    end
end

