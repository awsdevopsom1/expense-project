source common.sh
echo -e "${colour} installing the nginx \e[0m"
dnf install nginx -y &>>$log_file
status_check()

echo -e "${colour} copy expense config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
status_check()

echo -e "${colour} remove the default content that webserver is having \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check()

echo -e "${colour} download the frontend content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip  &>>$log_file
status_check()

echo -e "${colour} change directory & copy the content \e[0m"
cd /usr/share/nginx/html  &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
status_check

echo -e "${colour}  enable & restart the nignx \e[0m"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
status_check()



