RABBITMQ_PASSWORD=$1
if [ -z "$1" ]; then
  echo "INPUT PASSWORD NEDDED"
fi
PRINT "DOWNLOAD ERLANG"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> $LOG
STAT $?
PRINT "INSTALL ERLANG"
yum install erlang -y &>> $LOG
STAT $?
PRINT "DOWNLOAD RABBITMQ "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOG
STAT $?
PRINT "INSTALL RABBITMQ SERVICE"
yum install rabbitmq-server -y &>> $LOG
STAT $?
PRINT "ENABLE RABBITMQ SERVICE"
systemctl enable rabbitmq-server &>> $LOG
STAT $?
PRINT "START RABBITMQ SERVICE"
systemctl start rabbitmq-server &>> $LOG
STAT $?
PRINT "ADD USERNAME PASSWORD"
rabbitmqctl add_user roboshop ${RABBITMQ_PASSWORD} &>> $LOG
STAT $?
PRINT "SET TAGS"
rabbitmqctl set_user_tags roboshop administrator &>> $LOG
STAT $?
PRINT "SET PERMISSIONS"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG
STAT $?