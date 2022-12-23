# Back up


## Back-up commands

```
influxd backup -portable -db dbName /path/to/influxdb_backup
```
Restore command
```
influxd restore -portable -db dbName -newdb newDBName /path/to/influxdb_backup
```
>To add time range, should use timestampts (RFC3339 format)


## README

- [ ] The VM shoud have azure CLI, and crontab
- [ ] Set up backup_tar_path, backup_tar_file, backup_tmp_file
- [ ] Set up INFLUXDB related vars
- [ ] Set up AZURE_STORAGE_ACCOUNT related vars
- [ ] Set up crontab routine parameter
- [ ] run </path/to/script> {backup|restore|startcron}
- [ ] check the at </var/log/cron.log> to see successful or not

## Example

1. `./var/backups/influxdb_backup/influx_bc.sh startcron`
2. `./var/backups/influxdb_backup/influx_bc.sh bachup databaseName`
3. `./var/backups/influxdb_backup/influx_bc.sh restore`
> please use the *backup_tar_file and backup_tmp_file* that without a timestamp for testing. Then you can adjust accordingly
> the program will ask you to input two names. One is an existing database in the backup file, and the other is a non-existed database to restore our data.

### Problem current has:

In the function `inputValidation`, I want to check if the database we input is contained. The logic is correct and works well in a single execution. However, when doing this in the crontab task, it will pop out an error **Syntax error: "}" unexpected** at **split by \n to an array**, resulting in no execution of the task.
