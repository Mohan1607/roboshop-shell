echo -e "\e[34mDOWNLOADING MYSQL REPO\E[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
fi

echo -e "\e[34mDISABLE MYSQL 8\e[0m"
dnf module disable mysql -y
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
fi
echo -e "\e[34mINSTALL MYSQL SERVICE\e[0m"
yum install mysql-community-server -y
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
fi
echo -e "\e[34mENABLE MYSQL SERVICE\e[0m"
systemctl enable mysqld
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
fi
systemctl restart mysqld
echo -e "\e[34mSTART MYSQL SERVICE\e[0m"
if [ $? -eq 0 ] ; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e"\e[31mFAILURE\e[0m"
fi
echo show databases | mysql -uroot -pRoboshop@1
if [ $? -ne 0 ]
then
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
#echo ${DEFAULT_PASSWORD}
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" > /tmp/root-pass-sql
#ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
