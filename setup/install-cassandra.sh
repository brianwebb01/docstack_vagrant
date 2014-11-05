#!/bin/bash

sudo apt-get install openjdk-7-jre-headless libjna-java -y

echo "deb http://debian.datastax.com/community stable main" >> /etc/apt/sources.list.d/cassandra.sources.list

curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -

sudo apt-get update

sudo apt-get install dsc20=2.0.10-1 cassandra=2.0.10 -y

echo ">> Opscenter"

sudo apt-get install opscenter -y

sudo service opscenterd start