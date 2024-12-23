source common.sh

if [ -z "$1" ]; then
    echo Password input missing
    exit
fi    
MYSQL_ROOT_PASSWORD=$1

echo -e "${colour} disable and enable nodejs \e[0m"
dnf module disable nodejs -y  &>>$log_file
status_check

echo -e "${colour} enable nodejs \e[0m"
dnf module enable nodejs -y  &>>$log_file
status_check

echo -e "${colour} install nodejs \e[0m"
dnf install nodejs -y  &>>$log_file
status_check

echo -e "${colour} copy backend.service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} Add Application User \e[0m"
  useradd expense &>>$log_file
  status_check
fi

if [ ! -d /app ]; then
  echo -e "${color} Create Application Directory \e[0m"
  mkdir /app &>>$log_file
  status_check
fi

echo -e "${color} Delete old Application Content \e[0m"
rm -rf /app/* &>>$log_file
status_check

echo -e "${colour} Download the backend \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>log_file
status_check

echo -e "${colour} extract the app directory \e[0m"
cd /app  &>>log_file
unzip /tmp/backend.zip &>>log_file
status_check

echo -e "${colour} Download NodeJS Dependencies \e[0m"
npm install &>>$log_file
status_check

echo -e "${colour} install mysql client \e[0m"
dnf install mysql -y &>>log_file
status_check

echo -e "${colour} loadschema \e[0m"
mysql -h mysql-dev.awsdevopsom.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>log_file
status_check

echo -e "${colour} enable & restart the backend service \e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend 
status_check




