JAVA_HOME=/usr/lib/jvm/java-8-oracle

HDUSER_CLUSTER_ID=0

HADOOP_INSTALL_DIR=/opt/hadoop
HADOOP_VERSION=2.8.0

HADOOP_HOME=$HADOOP_INSTALL_DIR/$HADOOP_VERSION/hadoop-$HADOOP_VERSION

HDBACKUPFILES=(
    "$HADOOP_HOME/etc/hadoop/hadoop-env.sh" 
    "$HADOOP_HOME/etc/hadoop/core-site.xml"
    "$HADOOP_HOME/etc/hadoop/hdfs-site.xml"
    "$HADOOP_HOME/etc/hadoop/yarn-site.xml"
    "$HADOOP_HOME/etc/hadoop/mapred-site.xml.template"
)


BACKUP_DIR='./backup/setup'

mkdir -p $BACKUP_DIR

source ./hdsetup_func.sh

group=hadoop
mkdir -p $BACKUP_DIR/$group
for file in ${HDBACKUPFILES[*]}; do
    backup_file $file $BACKUP_DIR/$group
done


cp ./backup/setup/hadoop/hadoop-env.sh ./
apply_subst 'export JAVA_HOME=${JAVA_HOME}' "export JAVA_HOME=$JAVA_HOME" './hadoop-env.sh'




