# !/bin/bash -x

# back up yesterday data
export DATETIME=$(date "+%Y%m%d%H%M%S")
startDate=$(date "+%Y-%m-%dT00:00:00Z" -d "-1 days")
# timestamp=$(date +"%s_%d-%B-%Y_%A@%H%M")
backup_tar_file="influxdb_backup_$DATETIME.tar.gz"
backup_tmp_file="influxdb_backup_$DATETIME"
# backup_tar_file="influxdb_backup.tar.gz"
# backup_tmp_file="influxdb_backup"
backup_tar_path="/var/backups/influxdb_backup/"

# azure config
if ! az --version >>/dev/null 2>&1; then
    echo "az CLI env is required !!!"
    exit 1
fi

# may be used in VM
# export AZURE_STORAGE=${AZURE_STORAGE}
# : ${AZURE_STORAGE_SAS_TOKEN:?"AZURE_STORAGE_SAS_TOKEN env variable is required"}
# : ${INFLUXDB_HOST:?"INFLUXDB_HOST env variable is required"}
# : ${INFLUXDB_ORG:?"INFLUXDB_ORG env variable is required"}
# : ${INFLUXDB_TOKEN:?"INFLUXDB_TOKEN env variable is required"}

export BACKUP_PATH=${BACKUP_PATH:-/var/backups/influxdb_backup/$backup_tmp_file}
export BACKUP_ARCHIVE_PATH=${BACKUP_ARCHIVE_PATH:-$backup_tar_path$backup_tar_file}
export INFLUXDB_HOST=${INFLUXDB_HOST:-influxdb}
export INFLUXDB_ORG=${INFLUXDB_ORG:-influx}
export INFLUXDB_BACKUP_PORT=${INFLUXDB_BACKUP_PORT:-8086}
export AZURE_ACCOUNT_NAME=${AZURE_ACCOUNT_NAME:-mingst01}
export AZURE_CONTAINER_NAME=${AZURE_CONTAINER_NAME:-influxdb-bc}
export AZURE_FILE_NAME=${AZURE_FILE_NAME:-${backup_tar_file}}
export AZURE_STORAGE_AUTH_MODE=${AZURE_STORAGE_AUTH_MODE:-key}
export AZURE_ACCESS_TIER=${AZURE_ACCESS_TIER:-Cool}

# replace by a sas token. has to be container sas token, not the account.
export AZURE_STORAGE_SAS_TOKEN=${AZURE_STORAGE_SAS_TOKEN:-sp=racwdlm&st=2022-12-22T20:41:26Z&se=2022-12-23T16:41:26Z&spr=https&sv=2021-06-08&sr=c&sig=DrNzGoJNh5xMDpAyYPo0sLask35%2Bpn39Ae1s2ZoQlJE%3D}
# export AZURE_ACCESS_KEY=${AZURE_ACCESS_KEY:-}

# AZURE_STORAGE_CONNECTION_STRING: A connection string that includes the storage account key or a SAS token.
# export AZURE_STORAGE_CONNECTION_STRING=${AZURE_STORAGE_CONNECTION_STRING:-}
export CRON=${CRON:-"* * * * *"} #for testing。 if we want to back up at mid-night everyday, the format is  0 0 * * *

inputValidation() {
    # Get all the databases
    databases=$(influx -execute 'show databases' | sed -n -e '/----/,$p' | grep -v -e '----' -e '_internal')

    if [[ -z ${databases} ]]; then
        echo "no databases/measurements in current database"
        exit 1
    fi

    # SAVEIFS=$IFS # Save current IFS (Internal Field Separator)
    # IFS=$'\n'    # Change IFS to newline char
    # databasesArr=(${databases})
    # # split the `names` string into an array by the same name
    # IFS=$SAVEIFS # Restore original IFS
    # databasesArr=(${databases///n/}) # split by \n to an array
    # databasesArr=(${databases//$'\n'/})
    # databasesArr=(${databases//// })
    if [ -z $1 ]; then
        echo "Err: please input a database name"
        exit 1
    fi

    # check if the database we input is in our databases
    # if [[ -n $2 ]]; then # if the user gives two parameters, <new_database_name new>
    #     if [[ $2 != "new" ]]; then
    #         echo "wrong parameters"
    #         exit 1
    #     fi
    #     if [[ " ${databasesArr[*]} " =~ " ${1} " ]]; then
    #         echo "Err: please input a non-existed database name, using command - influx -execute show databases"
    #         exit 1
    #     fi
    # else
    #     if [[ ! " ${databasesArr[*]} " =~ " ${1} " ]]; then
    #         echo "Err: please input a valid database name, using command - influx -execute show databases"
    #         exit 1
    #     fi
    # fi

}

startcron() {
    if ! service cron status; then
        service cron start
    fi

    read -p 'database name: ' db

    inputValidation $db

    # echo "export PATH=$PATH:user/local/bin/influx" >>$HOME/.profile
    # echo "export INFLUXDB_HOST=$INFLUXDB_HOST" >>$HOME/.profile
    # echo "export INFLUXDB_TOKEN=$INFLUXDB_TOKEN" >>$HOME/.profile
    # echo "export INFLUXDB_ORG=$INFLUXDB_ORG" >>$HOME/.profile
    # echo "export INFLUXDB_BACKUP_PORT=$INFLUXDB_BACKUP_PORT" >>$HOME/.profile
    # echo "export BACKUP_PATH=$BACKUP_PATH" >>$HOME/.profile
    # echo "export BACKUP_ARCHIVE_PATH=$BACKUP_ARCHIVE_PATH" >>$HOME/.profile
    # echo "export DATETIME=$DATETIME" >>$HOME/.profile
    # echo "export AZURE_STORAGE_ACCOUNT=$AZURE_STORAGE_ACCOUNT" >>$HOME/.profile
    # #echo "export AZURE_STORAGE_KEY=$AZURE_STORAGE_KEY" >>$HOME/.profile
    # echo "export AZURE_STORAGE_SAS_TOKEN=$AZURE_STORAGE_SAS_TOKEN" >>$HOME/.profile
    # echo "export AZURE_STORAGE_AUTH_MODE=$AZURE_STORAGE_AUTH_MODE" >>$HOME/.profile
    # echo "Starting backup cron job with frequency '$1'" #default scheduler
    # echo "Please input databases you want to backup"

    # shoule be "$1 . $HOME/.profile; $0 backup $db >> /var/log/cron.log 2>&1" However, it will pop out an error with ./var/backups/influxdb_backup/influx_bc.sh: not found
    # it could be resolved by deleting the first dot '.'

    echo "$1 . $HOME/.profile;  /var/backups/influxdb_backup/influx_bc.sh backup $db >> /var/log/cron.log 2>&1" >/etc/cron.d/influxdbbackup
    cat /etc/cron.d/influxdbbackup
    crontab /etc/cron.d/influxdbbackup
    touch /var/log/cron.log
    crontab && tail -f /var/log/cron.log
}

backup() {
    echo $1 >>/test.txt
    # echo $1    # the value for line 202
    # echo "222" #>>/test.txt
    # the database name input in the function startcron
    echo "Backing up to $BACKUP_PATH"

    if [ -d $BACKUP_PATH ]; then
        rm -rf $BACKUP_PATH
    fi
    mkdir -p $BACKUP_PATH

    # back up command
    influxd backup -portable -db $1 -start $startDate $BACKUP_PATH

    if [ $? -ne 0 ]; then
        echo "Failed to backup to $BACKUP_PATH/"
        exit 1
    fi

    if [ -e $BACKUP_ARCHIVE_PATH ]; then
        rm -rf $BACKUP_ARCHIVE_PATH
    fi

    # Create archive
    echo $(date +"%d-%B-%Y@%H:%M:%S")" - Creating archive $BACKUP_PATH/$backup_tmp_file."
    tar -cvzf $BACKUP_ARCHIVE_PATH $BACKUP_PATH
    rm -rf $BACKUP_PATH
    echo "Sending file to azure cloud"

    # upload to blob
    if az storage blob upload --account-name $AZURE_ACCOUNT_NAME --container-name $AZURE_CONTAINER_NAME --name $AZURE_FILE_NAME --file $BACKUP_ARCHIVE_PATH --tier $AZURE_ACCESS_TIER --sas-token $AZURE_STORAGE_SAS_TOKEN --auth-mode $AZURE_STORAGE_AUTH_MODE; then
        echo "Backup file copied to azure"
    else
        echo "Backup file failed to upload"
        exit 1
    fi

    echo "Backup is finished!"
}

restore() {

    echo "input a database name that is backuped"
    read -p 'database name: ' oldDB
    inputValidation $oldDB

    echo "input a database name that isn't exist"
    read -p 'NEW database name using format <new_database_name new>: ' newDB
    inputValidation $newDB
    # newDBName=${newDB%% *}
    # echo ${newDBName}
    if [ -d $BACKUP_PATH ]; then
        echo "Removing out of date backup"
        rm -rf $BACKUP_PATH
    fi
    if [ -e $BACKUP_ARCHIVE_PATH ]; then
        echo "Removing out of date backup"
        rm -rf $BACKUP_ARCHIVE_PATH
    fi

    echo "Downloading latest backup from azure"
    if az storage blob download --account-name $AZURE_ACCOUNT_NAME --container-name $AZURE_CONTAINER_NAME --name $backup_tar_file --file $BACKUP_ARCHIVE_PATH --sas-token $AZURE_STORAGE_SAS_TOKEN --auth-mode $AZURE_STORAGE_AUTH_MODE; then
        echo "Downloaded"
    else
        echo "Failed to download latest backup"
        exit 1
    fi
    mkdir -p $BACKUP_PATH
    tar -xvzf $BACKUP_ARCHIVE_PATH #-C $BACKUP_PATH

    echo "Running restore"
    if influxd restore -portable -db $oldDB -newdb ${newDB%% *} $BACKUP_PATH; then
        echo "Successfully restored"
    else
        echo "Restore failed"
        exit 1
    fi
    echo "Done"
}

case "$1" in
"startcron")
    startcron "$CRON"
    ;;
"backup")
    backup $2
    ;;
"restore")
    restore
    ;;
*)
    echo "Invalid command '$@'"
    echo "Usage: $0 {backup|restore|startcron}"
    ;;
esac
