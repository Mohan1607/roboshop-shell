COMPONENT=catalogue
APP_LOC=/home/roboshop
CONTENT=${COMPONENT}
APP_USER=roboshop
source common.sh
NODEJS
#yum install nodejs -y
#useradd roboshop
#curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
#cd /home/roboshop
#rm -rf catalogue
#unzip /tmp/catalogue.zip
#mv catalogue-main catalogue
#cd /home/roboshop/catalogue
#npm install

#sed -i -e 's/MONGO_DNSNAME/mongodb.agileworld.online/' systemd.service


#mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
#systemctl daemon-reload
#systemctl start catalogue
#systemctl enable catalogue
