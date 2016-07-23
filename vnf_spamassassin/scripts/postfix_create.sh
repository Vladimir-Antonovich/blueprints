#!/bin/bash

set +e

export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update

#Install postfix
sudo debconf-set-selections <<< "postfix postfix/mailname string spamassassin.vnf.lab"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install postfix
sudo update-rc.d postfix enable

#configure postfix
sudo awk -vvar="${MY_DOMAIN}" '{if (/myhostname = .*/) print "myhostname = " var; else print $0}' /etc/postfix/main.cf > /tmp/main.cf && sudo mv /tmp/main.cf /etc/postfix/main.cf
echo "mynetworks_style = subnet" | sudo tee -a /etc/postfix/main.cf > /dev/null

#Add allowed network
sudo awk -vvar="${MY_NETWORK}" '{if (/mynetworks =/) print $0 " " var; else print $0}' /etc/postfix/main.cf > /tmp/main.cf && sudo mv /tmp/main.cf /etc/postfix/main.cf


# Apply changes
sudo /etc/init.d/postfix reload



