#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' elasticsearch 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo ">> Installing Elasticsearch GPG Key"
    wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -

    echo ">> Adding deb package"
    echo "deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main" >> /etc/apt/sources.list.d/elasticsearch.list

    echo ">> Updating apt"
    sudo apt-get update

    echo ">> Installing Java and Elasticsearch"
    sudo apt-get install openjdk-7-jre-headless elasticsearch -y

    echo ">> Java Installed"
    echo ">> Elasticsearch Installed"

    echo ">> Securing Elasticsearch configs"
    # sed -i '/network.bind_host/c\network.bind_host: localhost\n' /etc/elasticsearch/elasticsearch.yml
     if ! grep -q disable_dynamic "/etc/elasticsearch/elasticsearch.yml"; then
       echo -e "\n#disable dynamic scripts\nscript.disable_dynamic: true" >> /etc/elasticsearch/elasticsearch.yml
     fi


    echo ">> Starting Elasticsearch"
    sudo /etc/init.d/elasticsearch start

    echo ">> Running on port 9200. Make sure to add a firewall rule!"
    echo ">> Test with: curl -X GET 'http://localhost:9200'"
else
  echo ">> Elasticsearch already installed"
fi