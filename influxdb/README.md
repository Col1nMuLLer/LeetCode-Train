# Introduction 
This repo is to achieve influx backup trait by simply running `.py` file.

# Getting Started

1.	Installation process
- [ ] The VM shoud have azure CLI, python,and crontab
- [ ]Download the files, {backup.py} and {influx_bc.sh}  
Or in Linux system, we use `touch` to create these file and copy paste the code accordingly.  
- Excute `chmod -x influx_bc.sh` to make linux shell script excutable
- [ ] Set up backup_tar_path
- [ ] Set up INFLUXDB related vars
- [ ] Set up AZURE_STORAGE_ACCOUNT related vars
- [ ] Set up crontab routine parameter
- [ ] run python file <backup.py> eg: `python3 backup.py`, then input proper value accordingly
- [ ] check the at </var/log/cron.log> to see successful or not

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

## Back-up commands

```
influxd backup -portable -db dbName /path/to/influxdb_backup
```
Restore command
```
influxd restore -portable -db dbName -newdb newDBName /path/to/influxdb_backup
```
>To add time range, should use timestampts (RFC3339 format)


# Contribute
Mingxue Zhang: <mingxue.zhang@henkel.com>
