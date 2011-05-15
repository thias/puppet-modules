xinetd::serviceconf { "vmstat":
    service_type => "UNLISTED",
    port         => "24101",
    user         => "nobody",
    server       => "/usr/bin/vmstat",
}
