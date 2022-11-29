COMPONENT=cart
source common.sh

mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
PRINT "START ${COMPONENT} SERVICE"
systemctl start ${COMPONENT} &>> $LOG
STAT $?
PRINT "ENABLE ${COMPONENT} SERVICE"
systemctl enable ${COMPONENT} &>> $LOG
STAT $?