import os
import subprocess

# list of functions
functions = ["backup", "restore", "startcron"]

# excute linux command though os.popen()
databases = os.popen(
    "influx -execute 'show databases' | sed -n -e '/----/,$p' | grep -v -e '----' -e '_internal'").readlines()

# remove /n and space for each elements
# databases -> the list of all databases in current machine
databases = [x.strip() for x in databases if x.strip() != '']

print('Please input function {backup|restore|startcron}: ')
function = input()

# function doesn't match
if function not in functions:
    print("Invalid command" + function)
    print("Usage command : {backup|restore|startcron}")


if ("backup".__eq__(function)):
    print('Please input the database you want to backup: ')
    print('database name: ')
    db = input()
    if db in databases:
        # call the linux script
        subprocess.call(['sh', './influx_bc.sh', 'backup', db])
    else:
        print("Err: please input a valid database name, using command - influx -execute show databases")


if ("restore".__eq__(function)):
    print("input a database name that is backuped")
    print('database name: ')
    oldDB = input()
    # no need to check the already existed database name,
    # bacause it will pop out an error when we couldn't find it in storage account

    print("===============")
    print("input a database name that isn't exist")
    print("NEW database name:")
    print('new database name: ')
    newdb = input()

    # check wheather the database is new
    if newdb not in databases:
        subprocess.call(['sh', './influx_bc.sh', 'restore', oldDB, newdb])
    else:
        print("Err: please input a non-existed database name, using command - influx -execute show databases, with double quotes <show databases>")


if ("startcron".__eq__(function)):
    print('Please input the database you want to backup: ')
    print('database name: ')
    db = input()
    if db in databases:
        subprocess.call(['sh', './influx_bc.sh', 'startcron', db])
    else:
        print("Err: please input a valid database name, using command - influx -execute show databases")
