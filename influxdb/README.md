# Introduction 
This repo is to achieve influx backup trait by simply running `.py` file.

# Getting Started

1.	Installation process
- [ ] The VM shoud have azure CLI, python,and crontab
- [ ] Download the files, {backup.py} and {influx_bc.sh} should be in same folder  
Or in Linux system, we use `touch` to create these file and copy paste the code accordingly.  
- Excute `chmod 777 influx_bc.sh` to make linux shell script excutable
- [ ] Set up all related variables in ***backup_var.conf*** like {backup path, INFLUXDB, AZURE_STORAGE_ACCOUNT, crontab}
- [ ] Change the python file <backup.py>
- [ ] run python file <backup.py> eg: `python3 backup.py`, then input proper value accordingly
- [ ] check the at </var/log/cron.log> to see successful or not, might need to excute `chmod` to give the script privilege
- [ ] terminate with command `crontab /etc/cron.d/influxdbbackup stop` or with `sudo`
 
# Build and Test

1. Backup
```
ubuntu@ip-172-31-17-26:~$ python3 backup.py 

Please input function {backup|restore|startcron}: 
backup
Please input the database you want to backup: 
database name: 
in       

2023/01/09 16:07:44 backing up metastore to /var/backups/influxdb_backup/in_backup_20230109/meta.00
2023/01/09 16:07:44 backing up db=in
  ...
  ...
start=2023-01-08T00:00:00Z, end=0001-01-01T00:00:00Z
in_backup_20230109/20230109T160744Z.s40.tar.gz
  ...
09-January-2023@16:07:45 - Creating archive /var/backups/influxdb_backup/in_backup_20230109.tar.gz.
in_backup_20230109/
in_backup_20230109/20230109T160744Z.s39.tar.gz
  ...
in_backup_20230109/20230109T160744Z.s38.tar.gz
Sending file to azure cloud
Finished[#############################################################]  100.0000%
{
  "client_request_id": 
  ...
  ...
  ...
}
Backup file copied to azure
Backup is finished!
```
2. Restore
```
ubuntu@ip-172-31-17-26:~$ python3 backup.py 
Please input function {backup|restore|startcron}: 
restore
input a database name that is backuped
database name: 
in
===============
input a database name that isn't exist
NEW database name using format < new_database_name new >:
new database name: 
in_bc

Removing out of date backup
Downloading latest backup from azure
Finished[#############################################################]  100.0000%
{
  "container": "influxdb-bc",
  ...
  ...
  ...
}
Downloaded
in_backup_20230109/
in_backup_20230109/20230109T160744Z.s39.tar.gz
  ...
Running restore
  ...
2023/01/09 16:09:57 Restoring shard 37 live from backup 20230109T160744Z.s37.tar.gz
Successfully restored
Done
``` 

## Back-up & Restore commands


```bash
influxd backup -portable -db dbName /path/to/influxdb_backup
```

```
Usage: influxd restore -portable [options] PATH

Note: Restore using the '-portable' option consumes files in an improved Enterprise-compatible
  format that includes a file manifest.

Usage: influxd backup [options] PATH

    -portable
            Required to generate backup files in a portable format that can be restored to InfluxDB OSS or InfluxDB 
            Enterprise. Use unless the legacy backup is required.
    -host <host:port>
            InfluxDB OSS host to back up from. Optional. Defaults to 127.0.0.1:8088.
    -db <name>
            InfluxDB OSS database name to back up. Optional. If not specified, all databases are backed up when 
            using '-portable'.
    -rp <name>
            Retention policy to use for the backup. Optional. If not specified, all retention policies are used by 
            default.
    -shard <id>
            The identifier of the shard to back up. Optional. If specified, '-rp <rp_name>' is required.
    -start <2015-12-24T08:12:23Z>
            Include all points starting with specified timestamp (RFC3339 format). 
            Not compatible with '-since <timestamp>'.
    -end <2015-12-24T08:12:23Z>
            Exclude all points after timestamp (RFC3339 format). 
            Not compatible with '-since <timestamp>'.
    -since <2015-12-24T08:12:23Z>
            Create an incremental backup of all points after the timestamp (RFC3339 format). Optional. 
            Recommend using '-start <timestamp>' instead.
    -skip-errors 
            Optional flag to continue backing up the remaining shards when the current shard fails to backup. 
```

Restore command

```bash
influxd restore -portable -db dbName -newdb newDBName /path/to/influxdb_backup
```

```
Options:  
    -portable  
        Required to activate the portable restore mode. If not specified, the legacy restore mode is used.  
    -host  <host:port>  
            InfluxDB OSS host to connect to where the data will be restored. Defaults to '127.0.0.1:8088'.  
    -db    <name>  
            Name of database to be restored from the backup (InfluxDB OSS or InfluxDB Enterprise)  
    -newdb <name>  
            Name of the InfluxDB OSS database into which the archived data will be imported on the target system.  
            Optional. If not given, then the value of '-db <db_name>' is used.  The new database name must be unique
            to the target system.  
    -rp    <name>  
            Name of retention policy from the backup that will be restored. Optional.  
            Requires that '-db <db_name>' is specified.
    -newrp <name>  
            Name of the retention policy to be created on the target system. Optional. Requires that '-rp <rp_name>'
            is set. If not given, the '-rp <rp_name>' value is used.
    -shard <id>  
            Identifier of the shard to be restored. Optional. If specified, then '-db <db_name>' and '-rp <rp_name>' are
            required.
    PATH  
            Path to directory containing the backup files.  

> To add time range, should use timestampts (RFC3339 format)
```

# Contribute
Mingxue Zhang: <mingxue.zhang@henkel.com>
