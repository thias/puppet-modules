include nfs::v4client
nfs::v4mount { '/mnt/nfs1': device => '192.168.1.1:/nfs' }
nfs::v4mount { '/mnt/nfs2': device => '192.168.1.2:/nfs' }
