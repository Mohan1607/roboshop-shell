source common.sh
if [ -z "$1" ]; then
  echo input argument password needed
  exit
fi
PRINT "DOWNLOADING MYSQL REPO"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT $?

PRINT "DISABLE MYSQL 8"
dnf module disable mysql -y
STAT $?
PRINT "INSTALL MYSQL SERVICE"
yum install mysql-community-server -y
STAT $?
PRINT "ENABLE MYSQL SERVICE"
systemctl enable mysqld
STAT $?
PRINT "START MYSQL SERVICE"
systemctl restart mysqld
$?
PRINT "Change Mysql Default Password"
ROBOSHOP_MYSQL_PASSWORD=$1
echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}
echo $?
if [ $? -ne 0 ]
then
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
#echo ${DEFAULT_PASSWORD}
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
#ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
