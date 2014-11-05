#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo ">> Installing Nginx"
  sudo apt-get update
  sudo apt-get install -y nginx
else
  echo ">> Nginx already installed"
fi



if [ $(dpkg-query -W -f='${Status}' hhvm 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo ">> Installing HHVM"
    wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
    echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list
    sudo apt-get update
    sudo apt-get install -y hhvm
    sudo /usr/share/hhvm/install_fastcgi.sh

    echo ">> Setting HHVM to start on bootup"
    sudo update-rc.d hhvm defaults
    sudo service hhvm restart

    echo ">> Replacing PHP with alternative HHVM"
    sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60
else
    echo ">> HHVM already installed"
fi


if [ ! -f /etc/nginx/sites-available/localhost ];
then

echo ">> Disabling default Nginx site and setting up new vHost"
sudo cat <<EOT > /tmp/vhost
server {
    listen 80 default_server;

    root /vagrant/public;
    index index.html index.htm index.php;

    server_name localhost;

    access_log /var/log/nginx/localhost.access.log;
    error_log  /var/log/nginx/locahost.error.log error;

    charset utf-8;

    # serve static files directly
    location ~* ^.+.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt)$ {
        access_log        off;
        expires           max;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }

    error_page 404 /index.php;

    include hhvm.conf;  # The HHVM Magic Here

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOT
sudo cp /tmp/vhost /etc/nginx/sites-available/localhost
sudo ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx reload

else
    echo ">> vHost already configured"
fi
