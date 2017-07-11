HADOOP_INSTALL_DIR=/opt/hadoop
HADOOP_VERSION=2.8.0

sudo id hduser > /dev/null 2> /dev/null
is_hadoop_user_exist=$?
if [[ $is_hadoop_user_exist -ne 0 ]]; then
    echo 'Hadoop user does not exist.'

    echo 'Creating user "hadoop"'
    sudo addgroup hadoop
    sudo adduser --ingroup hadoop --quiet --disabled-password --gecos 'HadoopUser' hduser
    echo ''

    echo 'Installing ssh-server.'
    echo ''
    sudo apt-get install openssh-server
    sudo apt-get update

    echo ''
    echo 'Generate ssh-key for hduser'
    cd /home/hduser
    sudo -u hduser mkdir -p .ssh/authorized_keys   
    sudo -u hduser ssh-keygen -t rsa -P "" -f .ssh/hduser_id_rsa
    sudo cp .ssh/hduser_id_rsa.pub .ssh/authorized_keys/
    echo ''
else
    echo ''
fi

echo ''
if [[ -d $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION ]]; then
    echo 'Hadoop already installed in '$HADOOP_INSTALL_DIR/$HADDOP_VERSION
else
    echo 'Hadoop will be installed in '$HADOOP_INSTALL_DIR/$HADOOP_VERSION
    echo ''
    sudo mkdir -p $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    sudo chown -c -R hduser:hadoop $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    cd $HADOOP_INSTALL_DIR'/'$HADOOP_VERSION
    echo ''
    echo 'Downloading tar archive.'
    echo ''
    sudo -u hduser wget http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
    echo ''
    echo 'Extracting tar archive'
    echo ''
    sudo -u hduser tar xf hadoop-$HADOOP_VERSION.tar.gz
    sudo -u hduser rm hadoop-$HADOOP_VERSION.tar.gz
fi
