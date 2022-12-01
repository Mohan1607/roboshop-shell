COMPONENT=payment
PRINT "INSTALL PYTHON"
yum install python36 gcc python3-devel -y &>> $LOG
STAT $?
# useradd roboshop
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip

mv payment-main payment
cd /home/roboshop/payment
PRINT "INSTALL DEPENDENCIES"
pip3 install -r requirements.txt &>> $LOG
STAT $?

exit
1. Update the roboshop user and group id in `payment.ini` file.
2. Update SystemD service file

    Update `CARTHOST` with cart server ip

    Update `USERHOST` with user server ip

    Update `AMQPHOST` with RabbitMQ server ip.

3. Setup the service

# mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
# systemctl daemon-reload
# systemctl enable payment
# systemctl start payment