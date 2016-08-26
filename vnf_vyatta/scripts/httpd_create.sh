#! /bin/bash -e
ctx logger info "HTTPD is installing..."
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
