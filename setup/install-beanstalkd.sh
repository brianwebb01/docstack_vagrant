#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' beanstalkd 2>/dev/null | grep -c "ok installed") -eq 0 ];
then

echo ">> Installing Beanstalkd"

sudo apt-get install beanstalkd

echo ">> Setting up Beanstalkd Config"
sudo cat <<EOT > /tmp/beanstalkd

## Defaults for the beanstalkd init script, /etc/init.d/beanstalkd on
## Debian systems. Append ``-b /var/lib/beanstalkd'' for persistent
## storage.
BEANSTALKD_LISTEN_ADDR=0.0.0.0
BEANSTALKD_LISTEN_PORT=11300
BEANSTALKD_MAX_JOB_SIZE=5242880
DAEMON_OPTS="-l \$BEANSTALKD_LISTEN_ADDR -p \$BEANSTALKD_LISTEN_PORT -z \$BEANSTALKD_MAX_JOB_SIZE"

## Uncomment to enable startup during boot.
START=yes

EOT

sudo cp /tmp/beanstalkd /etc/default/beanstalkd

echo ">> Starting Beanstalkd"
sudo service beanstalkd stop
sudo service beanstalkd start

else
  echo ">> Beanstalkd already installed"
fi
