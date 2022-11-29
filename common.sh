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
  echo -e "\e[35m$1\E[0m"
}
LOG=/tmp/$COMPONENT.log
#rm -f $LOG
DOWNLOAD_APP_CODE(){
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
}
NODEJS()
{
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
  PRINT "DOWNLOAD ${COMPONENT} APPLICATION CODE"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> $LOG
  STAT $?
  PRINT "REMOVE THE PREVIOUS CONTENT OF ${COMPONENT}"
  cd /home/roboshop
  rm -rf ${COMPONENT} &>> $LOG
  STAT $?
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
  PRINT "CHANGE CONF FILE"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOG
  STAT $?
  PRINT "LOAD THE SYSTEMD FILE"
  systemctl daemon-reload &>> $LOG
  STAT $?
  PRINT "START ${COMPONENT} SERVICE"
  systemctl start ${COMPONENT} &>> $LOG
  STAT $?
  PRINT "ENABLE ${COMPONENT} SERVICE"
  systemctl enable ${COMPONENT} &>> $LOG
  STAT $?

}

