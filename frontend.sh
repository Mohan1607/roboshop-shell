COMPONENT=frontend
CONTENT=*
APP_LOC=/usr/share/nginx/html
source common.sh
PRINT "INSTALL NGINX SERVICE"
yum install nginx -y &>> $LOG
STAT $?
#curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
#cd /usr/share/nginx/html
#rm -rf *
#unzip /tmp/frontend.zip
DOWNLOAD_APP_CODE
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STSTEMD
#systemctl restart nginx
#systemctl enable nginx
