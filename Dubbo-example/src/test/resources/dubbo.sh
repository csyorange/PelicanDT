#!/bin/bash
cd /root
yum install wget
yum install unzip

if [ ! -f "/root/jdk-8u141-linux-x64.tar.gz" ];then
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
fi
if [ ! -d "/root/jdk1.8.0_141/" ];then
    tar -zxvf jdk-8u141-linux-x64.tar.gz
    sed -i '/export JAVA_HOME=/root/jdk1.8.0_141/d' /etc/profile
    sed -i '$ a\export JAVA_HOME=/root/jdk1.8.0_141' /etc/profile
    sed -i '/export PATH=$JAVA_HOME/bin:$PATH/d' /etc/profile
    sed -i '$ a\export PATH=$JAVA_HOME/bin:$PATH' /etc/profile
    source /etc/profile
fi

if [ ! -f "/root/apache-maven-3.0.5-bin.zip" ];then
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip
fi

if [ ! -d "/root/apache-maven-3.0.5/" ];then
    unzip apache-maven-3.0.5-bin.zip
    sed -i '/export MAVEN_HOME=/root/apache-maven-3.0.5/d' /etc/profile
    sed -i '$ a\export MAVEN_HOME=/root/apache-maven-3.0.5' /etc/profile
    sed -i '/export PATH=$MAVEN_HOME/bin:$PATH/d' /etc/profile
    sed -i '$ a\export PATH=$MAVEN_HOME/bin:$PATH' /etc/profile
    source /etc/profile
fi

if [ ! -f "/root/zookeeper-3.4.12.tar.gz" ];then
    wget http://mirror.bit.edu.cn/apache/zookeeper/stable/zookeeper-3.4.12.tar.gz
fi

if [ ! -d "/root/zookeeper-3.4.12" ];then
    tar -zxvf zookeeper-3.4.12.tar.gz
    cp /root/zookeeper-3.4.12/conf/zoo_sample.cfg /root/zookeeper-3.4.12/conf/zoo.cfg
fi

if [ ! -f "/root/dubbo-consumer-1.0-SNAPSHOT.jar" ];then
    wget http://moyuns.oss-cn-hangzhou.aliyuncs.com/dubbo-consumer-1.0-SNAPSHOT.jar
fi

if [ ! -f "/root/dubbo-provider-1.0-SNAPSHOT.jar" ];then
    wget http://moyuns.oss-cn-hangzhou.aliyuncs.com/dubbo-provider-1.0-SNAPSHOT.jar
fi

ps -fe | grep zookeeper | grep -v grep
if [ $? -ne 0 ]
then
   nohup sh /root/zookeeper-3.4.12/bin/zkServer.sh start >/dev/null 2>&1 &
   sleep 5s
fi

ps -fe | grep dubbo-provider-1.0 | grep -v grep
if [ $? -ne 0 ]
then
   nohup java -jar /root/dubbo-provider-1.0-SNAPSHOT.jar >/dev/null 2>&1 &
   sleep 5s
fi

ps -fe | grep dubbo-consumer-1.0 | grep -v grep
if [ $? -ne 0 ]
then
   nohup java -jar /root/dubbo-consumer-1.0-SNAPSHOT.jar >/dev/null 2>&1 &
   sleep 5s
fi