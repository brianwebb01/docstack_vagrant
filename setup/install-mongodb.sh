#!/bin/sh

if [ $(dpkg-query -W -f='${Status}' mongodb-10gen 2>/dev/null | grep -c "ok installed") -eq 0 ];
then

    echo ">> Installing MongoDB-10gen"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get update
    sudo apt-get -y install mongodb-10gen php-pear php5-dev

    echo ">> Installing mongo pecl extension"
    echo "no" > _no
    sudo pecl install mongo < _no
    rm _no


    echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
    sudo ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
    sudo service php5-fpm restart
fi