HDUSER_CLUSTER_ID=0

HADOOP_INSTALL_DIR=/opt/hadoop
HADOOP_VERSION=2.8.0


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


if [[ -f "/home/hduser/.ssh/authorized_keys/hduser_"$HDUSER_CLUSTER_ID"_id_rsa.pub" ]]; then
   echo 'Ssh-key already generated for hduser'
   echo ''
   echo ''
else
   echo 'Generate ssh-key for hduser'
   echo ''
   cd /home/hduser
   sudo -u hduser bash << EOF
   mkdir -p .ssh/authorized_keys
   ssh-keygen -t rsa -P "" -f ".ssh/hduser_"$HDUSER_CLUSTER_ID"_id_rsa"
   cp ".ssh/hduser_"$HDUSER_CLUSTER_ID"_id_rsa.pub" .ssh/authorized_keys/
EOF
   echo ''
   echo ''
fi


if [[ -d $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION ]]; then
    echo 'Hadoop already installed in '$HADOOP_INSTALL_DIR/$HADDOP_VERSION
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
EOF
fi
