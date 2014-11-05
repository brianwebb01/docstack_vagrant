# Vagrant Config

This repo is a stand alone repository of Vagrant config setup that came out of DocStack.io.  

The current configuration takes the following form:

1. Run `./setup/pre-provision.sh` to `git clone` all the public Chef repos hosted on GitHub.

2. `vagrant up`

  * This will setup a new Vagrant Box using `ubuntu/trusty64` with 512 Mb of memory.  It will be installed with:
    * Mysql (database created as `appdb` w/ credentials: root / Password1)
    * IP Set: `192.168.2.200`
    * Nginx
    * PHP5-FPM
    * Beanstalkd

Mysql is installed through Chef, everything else is installed through Bash scripts in this repo.