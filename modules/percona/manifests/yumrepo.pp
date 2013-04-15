# Class: percona::yumrepo
#
# Enable the Percona Yum repository.
#
# Parameters:
#  $ensure:
#    Whether the repo should be 'present' or 'absent'. Default: 'present'
#
# Sample Usage :
#  include percona::yumrepo
#
class percona::yumrepo ( $ensure = 'present' ) {

    # yumrepo types are removed using their $enabled, not the usual $ensure
    $yumrepo_enabled = $ensure ? {
        'present' => 1,
        'absent'  => 'absent',
    }

    yumrepo { 'percona':
        baseurl  => 'http://repo.percona.com/centos/$releasever/os/$basearch/',
        descr    => 'RHEL/CentOS $releasever - Percona',
        enabled  => $yumrepo_enabled,
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-percona',
    }

    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-percona':
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => "puppet:///modules/${module_name}/RPM-GPG-KEY-percona",
        ensure => $ensure,
    }

}

