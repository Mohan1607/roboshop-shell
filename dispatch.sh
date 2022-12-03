COMPONENT=dispatch
APP_USER=roboshop
CONTENT={COMPONENT}
source common.sh
PRINT "INSTALL GOLANG"
yum install golang -y &>> $LOG
STAT $?
DOWNLOAD_APP_CODE
mv dispatch-main dispatch $>> $LOG
cd dispatch $>> $LOG
PRINT "CREATING GO MOD FILE"
go mod init dispatch &>> $LOG
STAT $?
PRINT "INSTALL DEPENDENCIES"
go get &>> $LOG
STAT $?
PRINT "COMPILE ${COMPONENT} PACKAGES"
go build &>> $LOG
STAT $?
PRINT "CHANGE DISPATCH CONF FILE"
mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service &>> $LOG
STAT $?
PRINT "RELOAD THE CONF FILE"
systemctl daemon-reload &>> $LOG
STAT $?
PRINT "ENABLE THE DISPATCH SERVICE"
systemctl enable dispatch &>> $LOG
STAT $?
PRINT "START THE DISPATCH SERVICE"
systemctl start dispatch &>> $LOG
STAT $?