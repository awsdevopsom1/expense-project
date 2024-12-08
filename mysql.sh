source common.sh

if [ -z "$1" ]; then
  echo Password Input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1

echo -e "${colour} disable mysql \e[0m"
dnf module disable mysql -y &>>log_file
status_check()

echo -e "${colour} copy the mysql.repo \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>log_file
status_check()

echo -e "${colour} installing the mysql community server \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check()

echo -e "${colour} installing the mysql community server \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check()

echo -e "${colour} reset mysql DB passowrd \e[0m"
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>$log_file
status_check()

echo -e "${colour} start the service \e[0m"
systemctl enable mysqld  &>>$log_file
systemctl start mysqld  &>>$log_file
status_check()




