source ./hdsetup_func.sh


BACKUP_DIR=./backup/setup

SYSFILES=("/etc/fstab" "/etc/sysctl.conf")


mkdir -p $BACKUP_DIR

for file in ${SYSFILES[*]}; do
    backup_file $file
done
