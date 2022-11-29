COMPONENT=mongodb
APP_LOC=/tmp
CONTENT=mogodb-main
source common.sh
PRINT "DOWNLOAD YUM REPO FILE"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?
PRINT "INSTALL MOGODB SERVICE"
yum install -y mongodb-org &>> $LOG
STAT $?
PRINT "CHANGE THE LISTENIP OF MONGO CONF FILE"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG
STAT $?
#SYSTEMD
PRINT "ENABLE MONGODB SERVICE "
systemctl enable mongod &>> $LOG
STAT $?
PRINT "START MONGODB SERVICE"
systemctl restart mongod &>> $LOG
STAT $?
#curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
#cd /tmp
#unzip -o mongodb.zip
DOWNLOAD_APP_CODE
cd mongodb-main
PRINT "LOAD CATALOUGE SCHEMA"
mongo < catalogue.js &>> $LOG
STAT $?
PRINT "LOAD USER SCHEMA"
mongo < users.js &>> $LOG
STAT $?
