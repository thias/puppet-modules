# Main class for checks, *ONLY* meant to be included from nagios::client
# since it relies on variables from that class' scope.
#
class nagios::defaultchecks {

    # Default checks, enabled on all hosts
    nagios::check::cpu { $nagios::var::host_name: }
    if $::nagios_check_ping_disable != 'true' {
        nagios::check::ping { $nagios::var::host_name: }
    }
    if $::nagios_check_disk_disable != 'true' {
        nagios::check::disk { $nagios::var::host_name: }
    }
    if $::nagios_check_load_disable != 'true' {
        nagios::check::load { $nagios::var::host_name: }
    }
    if $::nagios_check_swap_disable != 'true' {
        nagios::check::swap { $nagios::var::host_name: }
    }
    if $::nagios_check_ntp_time_disable != 'true' {
        nagios::check::ntp_time { $nagios::var::host_name: }
    }
    if $::nagios_check_ram_disable != 'true' {
        nagios::check::ram { $nagios::var::host_name: }
    }
    # Conditional checks, enabled based on custom facts
    if $::nagios_check_megaraid_sas_disable != 'true' and
       $::nagios_pci_megaraid_sas == 'true' {
        nagios::check::megaraid_sas { $nagios::var::host_name: }
    } else {
        nagios::check::megaraid_sas { $nagios::var::host_name: ensure => absent }
    }
    if $::nagios_check_mptsas_disable != 'true' and
       $::nagios_pci_mptsas == 'true' {
        nagios::check::mptsas { $nagios::var::host_name: }
    } else {
        nagios::check::mptsas { $nagios::var::host_name: ensure => absent }
    }
    if $::nagios_check_httpd_disable != 'true' and
       $::nagios_httpd == 'true' {
        nagios::check::httpd { $nagios::var::host_name: }
    } else {
        nagios::check::httpd { $nagios::var::host_name: ensure => absent }
    }
    if $::nagios_check_nginx_disable != 'true' and
       $::nagios_httpd_nginx == 'true' {
        nagios::check::nginx { $nagios::var::host_name: }
    } else {
        nagios::check::nginx { $nagios::var::host_name: ensure => absent }
    }
    if $::nagios_check_membase_disable != 'true' and
       $::nagios_membase == 'true' {
        nagios::check::membase { $nagios::var::host_name: }
    } else {
        nagios::check::membase { $nagios::var::host_name: ensure => absent }
    }
    if $::nagios_check_moxi_disable != 'true' and
       $::nagios_moxi == 'true' {
        nagios::check::moxi { $nagios::var::host_name: }
    } else {
        nagios::check::moxi { $nagios::var::host_name: ensure => absent }
    }
    # Checks defaulting to be disabled, requiring explicit enable
    if $::nagios_check_jobs_status_enable == 'true' {
        nagios::check::jobs_status { $nagios::var::host_name: }
    } else {
        nagios::check::jobs_status { $nagios::var::host_name: ensure => absent }
    }

}

