# Class: clamav
#
# Since the Fedora/RHEL packages have changed a lot over time, but that only
# the latest version(s) of ClamAV are actually supported, no efforts are made
# to be compatible with older versions of the clamav-* packages.
#
# The current class and related definitions are meant for ClamAV 0.97.
#
class clamav {

    package { 'clamd': ensure => installed }

    # TODO: Include freshclam related stuff here?

}

