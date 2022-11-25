curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]
then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo "FAILURE"
dnf module disable mysql -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
echo show databases | mysql -uroot -pRoboshop@1
if [ $? -ne 0 ]
then
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
#echo ${DEFAULT_PASSWORD}
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" > /tmp/root-pass-sql
#ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
