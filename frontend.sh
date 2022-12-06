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
PRINT "MOVE THE CONF FILE"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
STAT $?
PRINT "Update RoboShop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.devopsworld.online/'  -e '/user/ s/localhost/dev-user.devopsworld.online/' -e '/cart/ s/localhost/dev-cart.devopsworld.online/' -e '/shipping/ s/localhost/dev-shipping.devopsworld.online/' -e '/payment/ s/localhost/dev-payment.devopsworld.online/' /etc/nginx/default.d/roboshop.conf
STAT $?
PRINT "START NGINX SERVICE"
systemctl restart nginx &>> $LOG
STAT $?
PRINT "ENABLE NGINX SERVICE"
systemctl enable nginx &>> $LOG
STAT $?
