#!/bin/bash

#set your expected domain name here
DOMAIN='ci.yourdomain.com'

sudo apt-get update
sudo apt-get upgrade -y

#using virtual host to run Jenkins
sudo apt-get install apache2 -y

#enable HTTP proxy
#https://wiki.jenkins.io/display/JENKINS/Running+Jenkins+behind+Apache
#https://www.howtoforge.com/tutorial/how-to-install-jenkins-with-apache-on-ubuntu-16-04/
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod ssl
sudo service apache2 restart

echo "Installing Jenkins..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
sudo service jenkins restart
#wait for Jenkins to start
sleep 30s

#via SSL - https://mensfeld.pl/2013/06/jenkins-behind-apache-with-https-proxy-pass-with-ssl/
sudo mkdir /etc/apache2/ssl
sudo openssl req -new -x509 -days 365 -keyout /etc/apache2/ssl/$DOMAIN.key -out /etc/apache2/ssl/$DOMAIN.crt -nodes -subj "/O=Jenkins/OU=Jenkins/CN=$DOMAIN"

#configure Apache virtual host, redirect http -> https, 8080
echo "<Virtualhost *:80>
     ServerName        $DOMAIN
     ProxyRequests     Off
     ProxyPreserveHost On
     AllowEncodedSlashes NoDecode
     RewriteEngine on
     RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,QSA,R=permanent]
</Virtualhost>

<VirtualHost *:443>
  ServerName $DOMAIN
  SSLEngine On
  SSLCertificateFile    /etc/apache2/ssl/$DOMAIN.crt
  SSLCertificateKeyFile /etc/apache2/ssl/$DOMAIN.key
  ProxyRequests     Off
  ProxyPass         /  http://localhost:8080/
  ProxyPassReverse  /  http://localhost:8080/
  ProxyPassReverse  /  http://$DOMAIN/
  <Proxy http://localhost:8080/*>
    Order allow,deny
    Allow from all
  </Proxy>
  ProxyPreserveHost on
</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/jenkins.conf > /dev/null

sudo a2ensite jenkins
sudo service apache2 restart

sleep 10s

#get initial pw on the log
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Done!"
