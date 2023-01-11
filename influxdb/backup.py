import os
import subprocess

# list of functions
functions = ["backup", "restore", "startcron"]


with open('./back_var.conf') as f:
    # Read the contents of the file into a string
    contents = f.read()

# Split the contents of the file by newline character
lines = contents.split('\n')

# create an empty dictionary
data = {}

flag_usr = False
flag_pas = False
# Iterate over the lines
for line in lines:
    # skip empty lines or commented lines
    if line.startswith("#") or line == "":
        continue
    # Split the line into key, value
    idx = line.index("=")
    key = line[:idx]
    value = line[idx+1:]
    key = key.strip()
    value = value.strip()
    # Remove leading and trailing whitespaces
    if "username".__eq__(key):
        # Remove the quotation marks around the value, if any
        value = value.strip('"')
        # add key, value to the dictionary
        data[key] = value
        flag_usr = True
    if "password".__eq__(key):
        value = value.strip('"')
        data[key] = value
        flag_usr = True
    if flag_usr and flag_pas:
        break

# Now you can access the username and password like this
username = data['username']
password = data['password']

# excute linux command though os.popen()
databases = os.popen(
    "influx -execute 'show databases' " + "-username " + username + " -password "+password+" | sed -n -e '/----/,$p' | grep -v -e '----' -e '_internal'").readlines()
# databases = subprocess.call(['sh', "influx -execute 'show databases'",
#                              '-username', username, '-password', password, " | sed -n -e '/----/,$p' | grep -v -e '----' -e '_internal'"]).readlines()
# remove /n and space for each elements
# databases -> the list of all databases in current machine
databases = [x.strip() for x in databases if x.strip() != '']

print('Please input function {backup|restore|startcron}: ')
function = input()
# print(databases)

# function doesn't match
if function not in functions:
    print("Invalid command" + function)
    print("Usage command : {backup|restore|startcron}")


if ("backup".__eq__(function)):
    if len(databases) == 0:
        print("Err: No database in the current influxDB or authorization failed")
        exit()
    print('Please input the database you want to backup: ')
    print('database name: ')
    db = input()
    if db in databases:
        # call the linux script
        subprocess.call(['bash', './influx_bc.sh', 'backup', db])
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

    newdb = input()

    # check wheather the database is new
    if newdb not in databases:
        subprocess.call(['bash', './influx_bc.sh', 'restore', oldDB, newdb])
    else:
        print("Err: please input a non-existed database name, using command - influx -execute show databases, with double quotes <show databases>")


if ("startcron".__eq__(function)):
    print('Please input the database you want to backup: ')
    print('database name: ')
    db = input()
    if db in databases:
        subprocess.call(['bash', './influx_bc.sh', 'startcron', db])
    else:
        print("Err: please input a valid database name, using command - influx -execute show databases")
