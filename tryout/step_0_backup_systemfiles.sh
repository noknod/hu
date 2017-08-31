source ./hdsetup_func.sh


BACKUP_DIR=./backup/setup

SYSFILES=("/etc/fstab" "/etc/sysctl.conf")


group=sys

mkdir -p $BACKUP_DIR/$group

for file in ${SYSFILES[*]}; do
    backup_file $file $BACKUP_DIR/$group
done
