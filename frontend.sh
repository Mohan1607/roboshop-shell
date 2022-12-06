COMPONENT=frontend
CONTENT=*
APP_LOC=/usr/share/nginx/html
source common.sh
PRINT "INSTALL NGINX SERVICE"
yum install nginx -y &>> $LOG
STAT $?
DOWNLOAD_APP_CODE
mv frontend-main/static/* .
PRINT "MOVE THE CONF FILE"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
STAT $?
PRINT "Update RoboShop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.agileworld.online/'  -e '/user/ s/localhost/dev-user.agileworld.online/' -e '/cart/ s/localhost/dev-cart.agileworld.online/' -e '/shipping/ s/localhost/dev-shipping.agileworld.online/' -e '/payment/ s/localhost/dev-payment.agileworld.online/' /etc/nginx/default.d/roboshop.conf
STAT $?
PRINT "START NGINX SERVICE"
systemctl restart nginx &>> $LOG
STAT $?
PRINT "ENABLE NGINX SERVICE"
systemctl enable nginx &>> $LOG
STAT $?
