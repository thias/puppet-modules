ovh::sshkey { 'root': }
ovh::sshkey { 'foo': options => [] }
ovh::sshkey { 'bar': ensure => absent }
