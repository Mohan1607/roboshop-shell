COMPONENT=redis
source common.sh
PRINT "DOWNLOAD REDIS"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG
STAT $?
PRINT "ENABLE REDIS 6.2"
dnf module enable redis:remi-6.2 -y &>> $LOG
STAT $?
PRINT "INSTALL REDIS"
yum install redis -y &>> $LOG
STAT $?
PRINT "CHANGE LISTEN IP OF REDIS CONF FILE"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> $LOG
STAT $?
PRINT "ENABLE REDIS SERVICE"
systemctl enable redis &>> $LOG
STAT $?
PRINT "START REDIS SERVICE"
systemctl restart redis
STAT $?