#!/bin/bash
sudo su
yum update -y
yum install nginx -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
aws s3 cp s3://jazz-s3-forcicd/html .
mv ./html index.html
mv ./index.html /var/www/html/index.html
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd