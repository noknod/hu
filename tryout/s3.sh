JwAVA_HOME=/usr/lib/jvm/java-8-oracle

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

#mkdir -p $BACKUP_DIR

source ./hdsetup_func.sh

#group=hadoop
#mkdir -p $BACKUP_DIR/$group
#for file in ${HDBACKUPFILES[*]}; do
#    backup_file $file $BACKUP_DIR/$group
#done

sudo -u hduser bash << EOF
source ./hdsetup_func.sh
apply_subst "'export JAVA_HOME=${JAVA_HOME}'" "export JAVA_HOME=$JAVA_HOME" $HADOOP_HOME/etc/hadoop//hadoop-env.sh
EOF

echo '*-- Checking Hadoop installation --*'
echo ''

sudo -u hduser bash << EOF
#exec $HADOOP_HOME/sbin/start-dfs.sh
EOF
echo ''

sudo -u hduser bash << EOF
#exec $HADOOP_HOME/sbin/start-yarn.sh
EOF
echo ''

sudo -u hduser bash << EOF
#jps
echo ''

$HADOOP_HOME/bin/hdfs dfsadmin -safemode leave
echo ''

#$HADOOP_HOME/bin/hdfs dfs -mkdir /user
#$HADOOP_HOME/bin/hdfs dfs -mkdir /user/hduser

$HADOOP_HOME/bin/hdfs dfs -mkdir input
$HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/core-site.xml input
$HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/yarn-site.xml input

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.0.jar grep input output 'dfs[a-z.]+'
echo ''

echo 'Output is'
$HADOOP_HOME/bin/hdfs dfs -cat output/*
echo ''
EOF

sudo -u hduser bash << EOF
#exec $HADOOP_HOME/sbin/stop-yarn.sh
EOF
echo ''
sudo -u hduser bash << EOF
#exec $HADOOP_HOME/sbin/stop-dfs.sh
EOF
echo ''

