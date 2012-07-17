#!/bin/sh
#
# Startup / shutdown script for the moxi server
#
# Copyright (c) 2011, Couchbase, Inc.
# All rights reserved
#
#
### BEGIN INIT INFO
# Provides:          moxi-server
# Required-Start:    $network $local_fs
# Required-Stop:
# Should-Start:      $named
# Should-Stop:
# Default-Start:        
# Default-Stop:         0 1 2 3 4 5 6
# Short-Description:    moxi server
# Description:          moxi server

### END INIT INFO

. /etc/init.d/functions

[ -f /etc/sysconfig/moxi-server ] && . /etc/sysconfig/moxi-server

PATH=/sbin:/usr/sbin:/bin:/usr/bin

DAEMON=/opt/moxi/bin/moxi
PIDFILE=/opt/moxi/moxi.pid

MOXI_CFG=/opt/moxi/etc/moxi.cfg
MOXI_CLUSTER_CFG=/opt/moxi/etc/moxi-cluster.cfg

test -f $DAEMON || exit 0
test -f $MOXI_CFG || exit 0
test -f $MOXI_CLUSTER_CFG || exit 0

start() {
    cd /opt/moxi
    ulimit -n 10240
    ulimit -c unlimited
    daemon --user moxi $DAEMON -d $OPTIONS -P $PIDFILE -Z $MOXI_CFG -z $MOXI_CLUSTER_CFG
    errcode=$?
    return $errcode
}

stop() {
    killproc -p $PIDFILE $DAEMON
    errcode=$?
    rm -f $PIDFILE
    return $errcode
}

running() {
    pidofproc -p $PIDFILE $DAEMON >/dev/null
    errcode=$?
    return $errcode
}

case $1 in
    start)
        if running ; then
            warning && echo "moxi server is already started"
            exit 0
        fi
        echo -n $"Starting moxi server"
        start
        echo
        ;;
    stop)
        echo -n $"Stopping moxi server"
        stop
        echo
        ;;
    restart)
        echo -n $"Stopping moxi server"
        stop
        echo
        echo -n $"Starting moxi server"
        start
        echo
        ;;
    status)
        if running ; then
            echo "moxi server is running"
            exit 0
        else
            echo "moxi server is not running"
            exit 3
        fi
        ;;
    *)
        echo "Usage: /etc/init.d/moxi-server {start|stop|restart|status}" >&2
        exit 3
esac
