class { 'nginx':
    worker_processes => $::processorcount,
}
