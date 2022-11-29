COMPONENT=cart
source common.sh
PRINT "DOWNLOAD NODEJS "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
STAT $?
PRINT "INSTALL NODEJS"
yum install nodejs -y &>> $LOG
STAT $?
PRINT "ADD APPLICATION USER"
id roboshop &>> $LOG
if [ $? -ne 0 ]; then
useradd roboshop  &>> $LOG
fi
STAT $?
PRINT "DOWNLOAD APPLICATION CODE"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
STAT $?
cd /home/roboshop
rm -rf ${COMPONENT}
PRINT "EXTRACT THE APP CONTENT"
unzip -o /tmp/${COMPONENT}.zip &>> $LOG
STAT $?
mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}
PRINT "INSTALL DEPENDENCIES"
npm install &>> $LOG
STAT $?
PRINT "CHANGE ENDPOINT LISTENIP"
sed -i -e 's/REDIS_ENDPOINT/redis.agileworld.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.agileworld.online/' systemd.service &>> $LOG
STAT $?

mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
PRINT "START ${COMPONENT} SERVICE"
systemctl start ${COMPONENT} &>> $LOG
STAT $?
PRINT "ENABLE ${COMPONENT} SERVICE"
systemctl enable ${COMPONENT} &>> $LOG
STAT $?