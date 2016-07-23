#!/bin/bash

set +e

export DEBIAN_FRONTEND=noninteractive

echo $(hostname -I) $(hostname) | sudo  tee --append /etc/hosts

LOG_DIR="/var/log/spamassassin"
DEFAULT_SPAMASSASSIN="/etc/default/spamassassin"
LOCAL_CONF="/etc/spamassassin/local.cf"

sudo apt-get -y update
sudo apt-get -y install spamassassin spamc
sudo groupadd spamd
sudo useradd -g spamd -s /bin/false -d $LOG_DIR spamd
sudo mkdir $LOG_DIR
sudo chown spamd:spamd $LOG_DIR
sudo sed -i 's/ENABLED=0/ENABLED=1/' $DEFAULT_SPAMASSASSIN
sudo sed -i 's/CRON=0/CRON=1/' $DEFAULT_SPAMASSASSIN
sudo sed -i "/^OPTIONS/ i SAHOME=$LOG_DIR" $DEFAULT_SPAMASSASSIN
sudo awk -vvar="${MAIL_SERVER_IP}" '{if (/OPTIONS=/) print "OPTIONS=\"--create-prefs --max-children 2 --username spamd -H ${SAHOME} -s ${SAHOME}spamd.log -i 0.0.0.0 -A " var "\""; else print $0}' $DEFAULT_SPAMASSASSIN > /tmp/spamassassin && sudo mv /tmp/spamassassin  $DEFAULT_SPAMASSASSIN

sudo service spamassassin start

# Config Spamassassin
sudo sed -i 's/# rewrite_header Subject *****SPAM*****/rewrite_header Subject *****SPAM*****/' $LOCAL_CONF
sudo sed -i 's/# required_score 5.0/required_score 3.0/' $LOCAL_CONF
sudo sed -i 's/# use_bayes 1/use_bayes 1/' $LOCAL_CONF
sudo sed -i 's/# bayes_auto_learn 1/bayes_auto_learn 1/' $LOCAL_CONF

sudo service spamassassin restart
