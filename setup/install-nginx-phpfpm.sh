#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo ">> Installing Nginx"
  sudo apt-get update
  sudo apt-get install -y nginx
else
  echo ">> Nginx already installed"
fi



if [ $(dpkg-query -W -f='${Status}' php5-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo ">> Installing php5-fpm"
    sudo apt-get install php5-fpm php5-mysql php5-common php5-dev php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-cgi php5-mcrypt php5-curl php5-gd php5-memcache php5-pspell php5-snmp php5-cli php5-imap -y

    sudo php5enmod mcrypt

    echo ">> Securing php5-fpm php.ini"
    sed -i '/cgi.fix_pathinfo/c\cgi.fix_pathinfo=0\n' /etc/php5/fpm/php.ini
    sudo service php5-fpm restart

    sudo service nginx stop
    sudo service nginx start
else
    echo ">> php5-fpm already installed"
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
    error_page 500 502 503 504 /50x.html;

    location ~ \.php\$ {
        try_files \$uri = 404;
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOT

    sudo cp /tmp/vhost /etc/nginx/sites-available/localhost
    sudo rm /etc/nginx/sites-enabled/localhost
    sudo ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

    if [ -f /etc/nginx/sites-enabled/default ];
    then
        sudo rm /etc/nginx/sites-enabled/default
    fi

    sudo service nginx stop
    sudo service nginx start

else
    echo ">> vHost already configured"
fi
