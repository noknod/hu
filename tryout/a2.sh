JAVA_HOME=/usr/lib/jvm/java-8-oracle

HDUSER_CLUSTER_ID=0

HADOOP_INSTALL_DIR=/opt/hadoop
HADOOP_VERSION=2.8.0

HADOOP_HOME=$HADOOP_INSTALL_DIR/$HADOOP_VERSION/hadoop-$HADOOP_VERSION


sudo id hduser > /dev/null 2> /dev/null
is_hadoop_user_exist=$?
if [[ $is_hadoop_user_exist -ne 0 ]]; then
    echo 'Hadoop user does not exist.'

    echo 'Creating user "hadoop"'
    echo ''
    sudo addgroup hadoop
    sudo adduser --ingroup hadoop --quiet --disabled-password --gecos 'HadoopUser' hduser
    echo ''
    echo ''
else
    echo 'Hadoop user exists'
    echo ''
    echo ''
fi


sudo dpkg -S openssh > /dev/null 2> /dev/null
is_openssh_installed=$?
if [[ $is_openssh_installed -ne 0 ]]; then
    echo 'Installing ssh-server.'
    echo ''
    sudo apt-get install openssh-server
    sudo apt-get update
    echo ''
    echo ''
else
    echo 'Ssh-server installed'
    echo ''
    echo ''
fi


# if [[ -f "/home/hduser/.ssh/authorized_keys/hduser_"$HDUSER_CLUSTER_ID"_id_rsa.pub" ]]; then
if [[ -f "/home/hduser/.ssh/authorized_keys" ]]; then
   echo 'Ssh-key already generated for hduser'
   echo ''
   echo ''
else
   echo 'Generate ssh-key for hduser'
   echo ''
   # cd /home/hduser
   sudo -u hduser bash << EOF
   cd /home/hduser
   # ssh-keygen -t rsa -P "" -f ".ssh/hduser_"$HDUSER_CLUSTER_ID"_id_rsa"
   ssh-keygen -t rsa -P "" -f "~/.ssh/id_rsa"
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
EOF
   echo ''
   echo ''
fi


if [[ -d $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION ]]; then
    echo 'Hadoop already installed in '$HADOOP_INSTALL_DIR/$HADDOP_VERSION
    echo ''
    echo ''
else
    echo 'Hadoop will be installed in '$HADOOP_INSTALL_DIR/$HADOOP_VERSION
    echo ''
    sudo mkdir -p $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    sudo chown -c -R hduser:hadoop $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    cd $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    sudo -u hduser bash << EOF
    echo ''
    echo 'Downloading tar archive.'
    echo ''
    wget http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
    echo ''
    echo 'Extracting tar archive'
    echo ''
    tar xf hadoop-$HADOOP_VERSION.tar.gz
    rm hadoop-$HADOOP_VERSION.tar.gz   
    mkdir -p hadoop_tmp/hdfs/namenode
    mkdir -p hadoop_tmp/hdfs/datanode
EOF
    echo ''
    echo ''
fi


echo 'Setup HADOOP environment variables'
echo ''
sudo -u hduser bash << EOF
source ./hdsetup_func.sh

cd /home/hduser

add_line "# -- HADOOP ENVIRONMNET VARIABLES start -- #" ".bashrc"
add_line "export JAVA_HOME=$JAVA_HOME" ".bashrc"
add_line "export HADOOP_HOME=$HADOOP_HOME" ".bashrc"
# add_line 'export HADOOP_CONF_DIR="\$HADOOP_HOME/etc/hadoop"' ".bashrc"
add_line 'export PATH="\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin"' ".bashrc"
add_line "# -- HADOOP ENVIRONMNET VARIABLES end -- #" ".bashrc"
EOF

echo ''
echo ''


# echo "Disabling ipv6"
# echo ''

# sudo bash << EOF
# source ./hdsetup_func.sh
# add_line "# disable ipv6" "/etc/sysctl.conf"
# add_line "net.ipv6.conf.all.disable_ipv6 = 1" "/etc/sysctl.conf"
# add_line "net.ipv6.default.disable_ipv6 = 1" "/etc/sysctl.conf"
# add_line "net.core.somaxconn = 1024" "/etc/sysctl.conf"
# EOF

# echo ''
# echo ''


