STAT(){
  if [ $? -eq 0 ] ; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
      echo "check errors in ${LOG} file"
      echo -e "\e[31mFAILURE\e[0m"
      exit
  fi
}
PRINT(){
  echo "-----------------------------$1---------------------------" &>>$LOG
  echo -e "\e[35m$1\e[0m"
}
LOG=/tmp/$COMPONENT.log
rm -f $LOG
DOWNLOAD_APP_CODE(){
if [ ! -z "$APP_USER" ]; then
PRINT "ADD APPLICATION USER"
id roboshop &>> $LOG
if [ $? -ne 0 ]; then
useradd roboshop  &>> $LOG
fi
STAT $?
fi
PRINT "DOWNLOAD APPLICATION CODE"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
STAT $?
PRINT "REMOVE PREVIUOS VERSION OF ${COMPONENT}"
cd ${APP_LOC}
rm -rf ${CONTENT} &>> $LOG
STAT $?
PRINT "EXTRACT THE APP CONTENT"
unzip -o /tmp/${COMPONENT}.zip &>> $LOG
STAT $?
}
SYSTEMD_CONFIG()
{
    PRINT "CHANGE ENDPOINT LISTENIP"
    sed -i -e 's/REDIS_ENDPOINT/redis.agileworld.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.agileworld.online/' -e 's/MONGO_ENDPOINT/mongo.agileworld.online/' -e 's/DB_HOST/mysql.agileworld.online/' -e 's/CART_ENDPOINT/cart.agileworld.online/' -e  's/CART_HOST/cart.agileworld.online/' -e 's/USER_HOST/user.agileworld.online/' -e 's/AMQP_HOST/rabbitmq.agileworld.online/'   /home/roboshop/${COMPONENT}/systemd.service &>> $LOG
    STAT $?
    PRINT "CHANGE CONF FILE"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOG
    STAT $?
    PRINT "RELOAD START ENABLE ${COMPONENT} SERVICE"
    systemctl daemon-reload &>> $LOG && systemctl start ${COMPONENT} &>> $LOG && systemctl enable ${COMPONENT} &>> $LOG
    STAT $?
}
NODEJS()
{
  PRINT "DOWNLOAD NODEJS "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
  STAT $?
  PRINT "INSTALL NODEJS"
  yum install nodejs -y &>> $LOG
  STAT $?
  APP_LOC=/home/roboshop
  CONTENT=${COMPONENT}
  APP_USER=roboshop
  DOWNLOAD_APP_CODE
  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}
  PRINT "INSTALL DEPENDENCIES"
  npm install &>> $LOG
  STAT $?
  SYSTEMD_CONFIG
}

JAVA(){
PRINT "INSTALL MAVEN"
yum install maven -y &>>$LOG
STAT $?
APP_LOC=/home/roboshop
CONTENT=${COMPONENT}
APP_USER=roboshop
DOWNLOAD_APP_CODE
mv ${COMPONENT}-main ${COMPONENT} &>> $LOG
cd ${COMPONENT} &>> $LOG
PRINT "MAVEN DEPENDENCIES"
mvn clean package &>>${LOG}
STAT $?
mv target/shipping-1.0.jar shipping.jar &>> $LOG
SYSTEMD_CONFIG

}
PYTHON(){
PRINT "INSTALL PYTHON"
yum install python36 gcc python3-devel -y &>> $LOG
STAT $?
APP_USER=roboshop
APP_LOC=/home/roboshop
CONTENT=${COMPONENT}
DOWNLOAD_APP_CODE
mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}
PRINT "INSTALL DEPENDENCIES"
pip3 install -r requirements.txt &>> $LOG
STAT $?
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid=${USER_ID}" -e "/gid/ c gid=${GROUP_ID}" ${COMPONENT}.ini
SYSTEMD_CONFIG

}



