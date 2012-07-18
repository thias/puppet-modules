# Define: postfix::server
#
# The title is used for the 'myhostname' parameter.
#
# When setting 'postgrey' to true, you might want to install a custom
# file as /etc/postfix/postgrey_whitelist_clients.local too.
#
# Sample Usage :
#
define postfix::server (
    # To install postfix-mysql package instead of plain postfix
    $mysql = false,
    # See the main.cf comments for help on these options
    $mydomain = false,
    $myorigin = '$myhostname',
    $inet_interfaces = "localhost",
    $inet_protocols = "all",
    $proxy_interfaces = false,
    $mydestination = '$myhostname, localhost.$mydomain, localhost',
    $local_recipient_maps = false,
    $unknown_local_recipient_reject_code = "550",
    $mynetworks_style = false,
    $mynetworks = false,
    $relay_domains = false,
    $relayhost = false,
    $relay_recipient_maps = false,
    $in_flow_delay = "1s",
    $alias_maps = "hash:/etc/aliases",
    $alias_database = "hash:/etc/aliases",
    $recipient_delimiter = false,
    $home_mailbox = false,
    $mail_spool_directory = false,
    $mailbox_command = false,
    $smtpd_banner = '$myhostname ESMTP $mail_name',
    $message_size_limit = false,
    $mail_name = false,
    $virtual_alias_domains = false,
    $virtual_alias_maps = false,
    $virtual_mailbox_domains = false,
    $virtual_mailbox_maps = false,
    $virtual_mailbox_base = false,
    $virtual_uid_maps = false,
    $virtual_gid_maps = false,
    $virtual_transport = false,
    $smtpd_sender_restrictions = [],
    $smtpd_recipient_restrictions = [],
    $ssl = false,
    $smtpd_sasl_auth = false,
    $smtpd_sasl_type = 'dovecot',
    $smtpd_sasl_path = 'private/auth',
    $sender_canonical_maps = false,
    # master.cf
    $smtp_content_filter = [],
    $submission = false,
    # EL5
    $submission_smtpd_enforce_tls = "yes",
    # EL6
    $submission_smtpd_tls_security_level = "encrypt",
    $submission_smtpd_sasl_auth_enable = "yes",
    $submission_smtpd_client_restrictions = "permit_sasl_authenticated,reject",
    $master_services = [],
    # Other files
    $header_checks = [],
    # Spamassassin
    $spamassassin        = false,
    $sa_required_hits    = "5",
    $sa_report_safe      = "0",
    $sa_rewrite_header   = [],
    $sa_trusted_networks = "10/8 172.16/12 192.168/16",
    $sa_skip_rbl_checks  = "1",
    $sa_loadplugin       = [ "Mail::SpamAssassin::Plugin::SPF" ],
    $sa_score            = [ "FH_DATE_PAST_20XX 0" ],
    $spampd_port         = '10026',
    $spampd_relayport    = '10027',
    $spampd_children     = '20',
    $spampd_maxsize      = '512',
    # Other filters
    $postgrey     = false,
    $clamav       = false
) {

    # Since this is a definition, make the title meaningful
    $myhostname = $title

    # Default has el5 files, for el6 a few defaults have changed
    if ( $::operatingsystem == "RedHat" ) and ( $::operatingsystemrelease >= 6 ) {
        $filesuffix = "-el6"
    } else {
        $filesuffix = ""
    }

    # Main package and service it provides
    $package_name = $mysql ? { true  => "postfix-mysql", false => "postfix", }
    package { $package_name: ensure => installed, alias => "postfix" }
    service { "postfix":
        require   => Package["postfix"],
        enable    => true,
        ensure    => running,
        hasstatus => true,
        restart   => "/sbin/service postfix reload",
    }

    file { "/etc/postfix/master.cf":
        content => template("postfix/master.cf${filesuffix}.erb"),
        notify  => Service["postfix"],
    }
    file { "/etc/postfix/main.cf":
        content => template("postfix/main.cf${filesuffix}.erb"),
        notify  => Service["postfix"],
    }

    # Optional certificates to be installed
    if ( $ssl and !defined(Tlsfiles[$ssl]) ) {
        tlsfiles { $ssl: }
    }

    # Optional Spamassassin setup (using spampd)
    if $spamassassin {
        # Main packages and service they provide
        package { [ "spamassassin", "spampd" ]: ensure => installed }
        # Note that we don't want the normal spamassassin (spamd) service
        service { "spampd":
            require   => Package["spampd"],
            enable    => true,
            ensure    => running,
            hasstatus => true,
        }
        # Override the options passed to spampd
        file { "/etc/sysconfig/spampd":
            content => template("postfix/sysconfig-spampd.erb"),
            notify  => Service["spampd"],
        }
        # Change the spamassassin options
        file { "/etc/mail/spamassassin/local.cf":
            require => Package["spamassassin"],
            content => template("postfix/spamassassin-local.cf.erb"),
            notify  => Service["spampd"],
        }
    }

    # Optional Postgrey setup
    if $postgrey {
        # Main package and service it provides
        package { "postgrey": ensure => installed }
        service { "postgrey":
            require   => Package["postgrey"],
            enable    => true,
            ensure    => running,
            # When stopped, status returns zero with 1.31-1.el5
            hasstatus => false,
        }
    }

    # Optional ClamAV setup (using clamsmtp)
    # Defaults to listen on 10025 and re-send on 10026
    if $clamav {
        include clamav::smtp
    }

    # Regex header_checks
    file { "/etc/postfix/header_checks":
        content => template("postfix/header_checks.erb"),
    }

    # Regex body_checks
    file { "/etc/postfix/body_checks":
        content => template("postfix/body_checks.erb"),
    }

}

