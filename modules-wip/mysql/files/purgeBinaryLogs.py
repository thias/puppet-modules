#!/usr/bin/env /usr/bin/python
# -*- coding: ISO-8859-1 -*-

import MySQLdb
import getopt
import sys
import ConfigParser, os

def usage():
    print purgeBinaryLogs.__doc__
    sys.exit(-1)

def mysqlConnect(mysqluser,mysqlpass,mysqlhost="localhost",mysqldb=""):
    """Connects with the database and returns the cursor"""
    db=MySQLdb.connect(user=mysqluser,passwd=mysqlpass,host=mysqlhost,db=mysqldb)
    return db.cursor()
    pass

def mysqlDisconnect(cursor):
    cursor.close
    pass

def deep_list(x):
    """fully copies trees of tuples to a tree of lists.
       deep_list( (1,2,(3,4)) ) returns [1,2,[3,4]]"""
    if type(x)!=type( () ):
        return x
    return map(deep_list,x)

def purgeBinaryLogs(user,password,host,min_logs=100,debug=1):
    """Deletes MySQL binary logs keeping the x last ones
usage: purgeBinaryLogs.py -u mysql_user -H mysql_host -p mysql_password -l min_logs -d
usage: purgeBinaryLogs.py -u mysql_user -H mysql_host -p mysql_password -l min_logs -d
 -u: MySQL user
 -H: MySQL host
 -p: MySQL password
 -l: Number of binlogs to keep
 -d: Be verbose (debug)"""
    cursor = mysqlConnect(user,password,host)
    cursor.execute("show master logs")
    logs = cursor.fetchall()
    if debug >= 1:
        print "Deleting all logs before " + logs[-int(min_logs):][0][0]
    cursor.execute("purge master logs to \'" + logs[-int(min_logs):][0][0] + "\'")
    mysqlDisconnect(cursor)

if __name__ == "__main__":
    user = None
    password = None
    host = None
    min_logs = None
    debug = 0

    try:
        # try to read config from .my.cnf
        config = ConfigParser.ConfigParser()
        if os.getenv("USER") == "root":
            configfile = "/root/.my.cnf"
        else:
            configfile = "/home/" + os.getenv("USER") + "/.my.cnf"
        config.read(configfile)
        user = config.get('client', 'user')
        password = config.get('client', 'password')
    except:
	pass

    try:
        opt_list = getopt.getopt(sys.argv[1:], "hvu:p:H:l:d")
    except getopt.GetoptError:
        usage()
    for opt in opt_list[0]:
        if opt[0]=="-h":
            usage()
        elif opt[0]=="-v":
            usage()
        elif opt[0]=="-u":
            user = opt[1]
        elif opt[0]=="-p":
            password = opt[1]
        elif opt[0]=="-H":
            host = opt[1]
        elif opt[0]=="-l":
            min_logs = opt[1]
        elif opt[0]=="-d":
            debug=1
        else:
            usage()
    if user and password and host and min_logs:
        purgeBinaryLogs(user,password,host,min_logs,debug)
    else:
        usage()
