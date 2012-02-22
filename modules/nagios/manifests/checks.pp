# Main class for checks, *ONLY* meant to be included from nagios::client
# since it relies on variables from that class.
#
class nagios::checks {

    # Default checks, enabled on all hosts
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
    if $::nagios_check_cpu_disable != 'true' {
        nagios::check::cpu { $nagios::var::host_name: }
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

/*
    if $nagios_disable_puppet != "true" {
        nagios::check::puppet {"puppet":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::puppet {"puppet": ensure => absent }
    }
    if $nagios_disable_ssh != "true" {
        nagios::check::ssh {"ssh":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::ssh {"ssh": ensure => absent }
    }
    if $nagios_disable_zombies != "true" {
        nagios::check::zombie_procs {"zombies":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::zombie_procs {"zombies": ensure => absent }
    }
    if $nagios_disable_crond != "true" {
        nagios::check::crond {"crond":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::crond {"crond": ensure => absent }
    }
    if $nagios_disable_postfix != "true" {
        nagios::check::postfix {"postfix":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::postfix {"postfix": ensure => absent }
    }
    if $nagios_disable_conntrack!= "true" {
        nagios::check::conntrack {"conntrack":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::conntrack {"conntrack": ensure => absent }
    }
    if $nagios_disable_snmpd != "true" {
        nagios::check::snmpd {"snmpd":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::snmpd {"snmpd": ensure => absent }
    }
    if $::operatingsystem =~ /^(RedHat|CentOS)$/ and $::operatingsystemrelease < 6 {
        if $nagios_disable_klogd != "true" {
            nagios::check::klogd {'klogd': notification_period => 'workhours' }
        } else {
            nagios::check::klogd {'klogd': ensure => absent }
        }
        if $nagios_disable_syslogd != 'true' {
            nagios::check::syslogd {'syslogd':
                notification_period => 'workhours',
                check_period => $nagios_check_period,
            }
        } else {
            nagios::check::syslogd {'syslogd': ensure => absent }
        }
    } else {
        if $nagios_disable_syslogd != 'true' {
            nagios::check::syslogd {'syslogd':
                notification_period => 'workhours',
                check_period => $nagios_check_period,
                processname => 'rsyslogd',
            }
        } else {
            nagios::check::syslogd {'syslogd': ensure => absent }
        }
    }

    if $::mysqld_exists == "true" {
        # Main MySQL
        if $nagios_disable_mysql != "true" {
            nagios::check::mysql {"mysql":
                notification_period => $nagios_notification_period,
                check_slave => $mysql_is_slave,
                lag_warning => $nagios_mysql_lag_warning,
                lag_critical => $nagios_mysql_lag_critical
            }
        } else {
            nagios::check::mysql {"mysql": ensure => absent }
        }
        # MySQL Health checks
        if $nagios_disable_mysql_health != "true" and $nagios_disable_mysql != "true" {
            if $nagios_disable_mysql_health_threads_connected != "true" {
                nagios::check::mysql_health { "threads-connected":
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_mysql_health_threads_connected_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
               }
            } else {
                nagios::check::mysql_health { "threads-connected": ensure => absent }
            }
            if $nagios_disable_mysql_health_threadcache_hitrate != "true" {
                nagios::check::mysql_health { "threadcache-hitrate":
                    # Usually around 98% of the threads are cached
                    # extra_params => "--warning 80: -c 60:"
                    extra_params => $nagios_check_mysql_health_threadcache_hitrate_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "threadcache-hitrate": ensure => absent }
            }
            if $nagios_disable_mysql_health_qcache_hitrate != "true" {
                nagios::check::mysql_health { "qcache-hitrate":
                    #extra_params => "--warning 50: -c 10:",
                    extra_params => $nagios_check_mysql_health_qcache_hitrate_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                    notification_period => 'workhours',
                }
            } else {
                nagios::check::mysql_health { "qcache-hitrate": ensure => absent }
            }
            if $nagios_disable_mysql_health_qcache_lowmem_prunes != "true" {
                nagios::check::mysql_health { "qcache-lowmem-prunes":
                    extra_params => $nagios_check_mysql_health_qcache_lowmem_prunes_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "qcache-lowmem-prunes": ensure => absent }
            }
            if $nagios_disable_mysql_health_keycache_hitrate != "true" {
                nagios::check::mysql_health { "keycache-hitrate":
                    # Usually around 98% of the keys are cached
                    # extra_params => "--warning 80: -c 60:",
                    extra_params => $nagios_check_mysql_health_keycache_hitrate_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "keycache-hitrate": ensure => absent }
            }
            if $nagios_disable_mysql_health_tablecache_hitrate != "true" {
                nagios::check::mysql_health { "tablecache-hitrate":
                    #extra_params => "--warning 80: -c 60:",
                    extra_params => $nagios_check_mysql_health_tablecache_hitrate_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "tablecache-hitrate": ensure => absent }
            }
            if $nagios_disable_mysql_health_table_lock_contention != "true" {
                nagios::check::mysql_health { "table-lock-contention":
                    extra_params => $nagios_check_mysql_health_table_lock_contention_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "table-lock-contention": ensure => absent }
            }
            if $nagios_disable_mysql_health_tmp_disk_tables != "true" {
                nagios::check::mysql_health { "tmp-disk-tables":
                    extra_params => $nagios_check_mysql_health_tmp_disk_tables_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "tmp-disk-tables": ensure => absent }
            }
            if $nagios_disable_mysql_health_slow_queries != "true" {
                nagios::check::mysql_health { "slow-queries":
                    extra_params => $nagios_check_mysql_health_slow_queries_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "slow-queries": ensure => absent }
            }
            if $nagios_disable_mysql_health_long_runing_procs != 'true' {
                nagios::check::mysql_health { 'long-running-procs':
                    extra_params => $nagios_check_mysql_health_long_runing_procs_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                    notification_period => 'workhours',
                }
            } else {
                nagios::check::mysql_health { 'long-running-procs': ensure => absent }
            }
            if $nagios_disable_mysql_health_openfiles!= "true" {
                nagios::check::mysql_health { "open-files":
                    extra_params => $nagios_check_mysql_health_openfiles_extra_params,
                    contactgroup => $nagios_contactgroup_mysql_health,
                }
            } else {
                nagios::check::mysql_health { "open-files": ensure => absent }
            }
        }
    }
    if $::oracle_exists == 'true' {
        if $nagios_disable_oracle_health != 'true' {
            if $nagios_disable_oracle_health_sga_dictionary_cache_hit_ratio != 'true' {
                nagios::check::oracle_health { 'sga-dictionary-cache-hit-ratio':
                    notification_period => 'workhours',
                    extra_params => $nagios_check_oracle_health_sga_dictionary_cache_hit_ratio_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'sga-dictionary-cache-hit-ratio': ensure => absent }
            }
            if $nagios_disable_oracle_health_tnsping != 'true' {
                nagios::check::oracle_health { 'tnsping':
                    notification_period => $nagios_notification_period,
                    contactgroup => 'dba',
                }
            }
            else {
               nagios::check::oracle_health { 'tnsping': ensure => absent }
           }
            if $nagios_disable_oracle_health_tablespace_free != 'true' {
                nagios::check::oracle_health { 'tablespace-free':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_tablespace_free_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'tablespace-free': ensure => absent }
            }
            if $nagios_disable_oracle_health_invalid_objects != 'true' {
                nagios::check::oracle_health { 'invalid-objects':
                    notification_period => 'workhours',
                    extra_params => $nagios_check_oracle_health_invalid_objects_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'invalid-objects': ensure => absent }
            }
            if $nagios_disable_oracle_health_sga_latches_hit_ratio != 'true' {
                nagios::check::oracle_health { 'sga-latches-hit-ratio':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_sga_latches_hit_ratio_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'sga-latches-hit-ratio': ensure => absent }
            }
            if $nagios_disable_oracle_health_latch_contention != 'true' {
                nagios::check::oracle_health { 'latch-contention':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_latch_contention_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'latch-contention': ensure => absent }
            }
            
            if $nagios_disable_oracle_health_pga_in_memory_sort_ratio != 'true' {
                nagios::check::oracle_health { 'pga-in-memory-sort-ratio':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_pga_in_memory_sort_ratio_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'pga-in-memory-sort-ratio': ensure => absent }
            }
            if $nagios_disable_oracle_health_redo_io_traffic != 'true' {
                nagios::check::oracle_health { 'redo-io-traffic':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_redo_io_traffic_extra_params,
                    contactgroup => 'dba',
                }
            }
            else {
                nagios::check::oracle_health { 'redo-io-traffic': ensure => absent }
            }

            if $nagios_disable_oracle_health_tablespace_can_allocate_next != 'true' {
                nagios::check::oracle_health { 'tablespace-can-allocate-next':
                    notification_period => $nagios_notification_period,
                    extra_params => $nagios_check_oracle_health_tablespace_can_allocate_next_extra_params,
                    contactgroup => 'dba',
                    normal_check_interval => '60',
                    notification_interval => '60',
                }
            }
            else {
                nagios::check::oracle_health { 'tablespace-can-allocate-next': ensure => absent }
            }
       }
    }
    if $::raid_software == "true" {
        if $nagios_disable_raid_software != "true" {
            nagios::check::mdraid {"raid_software": notification_period => $nagios_notification_period }
        } else {
            nagios::check::mdraid {"raid_software": ensure => absent }
        }
    }

    if $::ldap_exists == "true" {
        if $nagios_disable_ldap != "true" {
            if $nagios_ldap_ssl == "false" {
                nagios::check::ldap {"ldap_conn":
                    notification_period => $nagios_notification_period,
                    ssl => false
                }
            } else {
                nagios::check::ldap {"ldap_conn": notification_period => $nagios_notification_period }
            }
        } else {
            nagios::check::ldap {"ldap_conn": ensure => absent }
        }
        if $nagios_disable_ldapdb != "true" {
            nagios::check::ldapdb {"ldap_db": notification_period => $nagios_notification_period }
        } else {
            nagios::check::ldapdb {"ldap_db": ensure => absent }
        }
        if $nagios_disable_ldaprep != "true" {
            nagios::check::ldaprep {"ldap_rep": notification_period => $nagios_notification_period }
        } else {
            nagios::check::ldaprep {"ldap_rep": ensure => absent }
        }
    }

    if ( $::virtual == "xen0" or $virtual == "physical" or $puppet_noop == "true" ) and $nagios_disable_puppet_changes != "true" {
        nagios::check::puppet_changes {"puppet_changes":
            notification_period => $nagios_notification_period,
            check_period => $nagios_check_period,
        }
    } else {
        nagios::check::puppet_changes {"puppet_changes": ensure => absent }
    }

    if $::virtual == "xen0" {
        if $nagios_disable_xen != "true" {
            nagios::check::xen {"xen": notification_period => $nagios_notification_period }
        } else {
            nagios::check::xen {"xen": ensure => absent }
        }
    }

    if $::radiusd_exists == "true" {
        if $nagios_disable_radius != "true" {
            nagios::check::radius {"radius": notification_period => $nagios_notification_period }
        } else {
            nagios::check::radius {"radius": ensure => absent }
        }
    }

    if $::interfaces =~ /bond/ {
        if $nagios_disable_bonding != "true" {
            nagios::check::bonding {"bonding":
                notification_period => $nagios_notification_period,
                check_period => $nagios_check_period,
                extra_params => $nagios_check_bonding_extra_params
            }
        } else {
            nagios::check::bonding {"bonding": ensure => absent }
        }
    }

*/

}

