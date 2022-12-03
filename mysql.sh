COMPONENT=mysql
source common.sh
if [ -z "$1" ]; then
  echo input argument password needed
  exit 1
fi
PRINT "DOWNLOADING MYSQL REPO"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>> $LOG
STAT $?
PRINT "DISABLE MYSQL 8"
dnf module disable mysql -y &>> $LOG
STAT $?
PRINT "INSTALL MYSQL SERVICE"
yum install mysql-community-server -y &>> $LOG
STAT $?
PRINT "ENABLE MYSQL SERVICE"
systemctl enable mysqld &>> $LOG
STAT $?
PRINT "START MYSQL SERVICE"
systemctl restart mysqld &>> $LOG
STAT $?
PRINT "Change Mysql Default Password"
ROBOSHOP_MYSQL_PASSWORD=$1
echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>> $LOG
if [ $? -ne 0 ]
then
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}') &>> $LOG
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" &>> $LOG
fi
STAT $?
PRINT "UNINSTALL VALIDATE PASSWORD PLUGIN"
echo "show plugins" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} | grep validate_password &>> $LOG
if [ $? -eq 0 ]; then
echo "uninstall plugin validate_password" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>> $LOG
fi
STAT $?
APP_LOC=/tmp
CONTENT=mysql-main
DOWNLOAD_APP_CODE
cd mysql-main &>> $LOG
PRINT "LOAD SHIPPING SCHEMA"
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>> $LOG
STAT $?

