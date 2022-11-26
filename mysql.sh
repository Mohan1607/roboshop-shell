echo -e "\e[35mDOWNLOADING MYSQL REPO\E[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
    exit
fi

echo -e "\e[35mDISABLE MYSQL 8\e[0m"
dnf module disable mysql -y
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
    exit
fi
echo -e "\e[35mINSTALL MYSQL SERVICE\e[0m"
yum install mysql-community-server -y
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
    exit
fi
echo -e "\e[35mENABLE MYSQL SERVICE\e[0m"
systemctl enable mysqld
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
    exit
fi
systemctl restart mysqld
echo -e "\e[35mSTART MYSQL SERVICE\e[0m"
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
     exit
fi
#ROBOSHOP_MYSQL_PASSWORD=$1
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
