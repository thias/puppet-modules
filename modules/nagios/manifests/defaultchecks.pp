# Main class for checks, *ONLY* meant to be included from nagios::client
# since it relies on variables from that class' scope.
#
class nagios::defaultchecks {

    if $::nagios_check_swap_disable != 'true' {
        nagios::check::swap { $nagios::client::host_name: }
    }
    if $::nagios_check_ntp_time_disable != 'true' {
        nagios::check::ntp_time { $nagios::client::host_name: }
    }
    if $::nagios_check_ram_disable != 'true' {
        nagios::check::ram { $nagios::client::host_name: }
    }
    # Conditional checks, enabled based on custom facts
    if $::nagios_check_megaraid_sas_disable != 'true' and
       $::nagios_pci_megaraid_sas == 'true' {
        nagios::check::megaraid_sas { $nagios::client::host_name: }
    } else {
        nagios::check::megaraid_sas { $nagios::client::host_name: ensure => absent }
    }
    if $::nagios_check_mptsas_disable != 'true' and
       $::nagios_pci_mptsas == 'true' {
        nagios::check::mptsas { $nagios::client::host_name: }
    } else {
        nagios::check::mptsas { $nagios::client::host_name: ensure => absent }
    }
    if $::nagios_check_nginx_disable != 'true' and
       $::nagios_httpd_nginx == 'true' {
        nagios::check::nginx { $nagios::client::host_name: }
    } else {
        nagios::check::nginx { $nagios::client::host_name: ensure => absent }
    }
    if $::nagios_check_membase_disable != 'true' and
       $::nagios_membase == 'true' {
        nagios::check::membase { $nagios::client::host_name: }
    } else {
        nagios::check::membase { $nagios::client::host_name: ensure => absent }
    }
    if $::nagios_check_couchbase_disable != 'true' and
       $::nagios_couchbase == 'true' {
        nagios::check::couchbase { $nagios::client::host_name: }
    } else {
        nagios::check::couchbase { $nagios::client::host_name: ensure => absent }
    }
    if $::nagios_check_moxi_disable != 'true' and
       $::nagios_moxi == 'true' {
        nagios::check::moxi { $nagios::client::host_name: }
    } else {
        nagios::check::moxi { $nagios::client::host_name: ensure => absent }
    }

}

