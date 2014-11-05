#!/bin/bash
#
mkdir -p setup/vg_recipes/cookbooks setup/vg_recipes/roles setup/vg_recipes/data_bags

cd setup/vg_recipes/cookbooks

REPOS=(
    "https://github.com/sethvargo/chef-sugar.git"
	"https://github.com/opscode-cookbooks/apt.git"
	"https://github.com/opscode-cookbooks/build-essential.git"
	"https://github.com/fnichol/chef-user"
	"https://github.com/opscode-cookbooks/openssh"
	"https://github.com/dcrosta/cookbook-simple-iptables"
	"https://github.com/opscode-cookbooks/imagemagick.git"
	"https://github.com/opscode-cookbooks/sudo.git"
	"https://github.com/opscode-cookbooks/postfix.git"
	"https://github.com/opscode-cookbooks/openssl.git"
	"https://github.com/brianwebb01/mysql.git"
)

if [ "$(ls -A .)" ]; then
    echo "Cookbooks exist, updating each from GIT..."
    for i in ./* ; do
	  if [ -d "$i" ]; then
	  	echo ""
	  	echo "Updating $i"
	    cd $i && git pull && cd ..
	  fi
	done
else
    echo "NO cookbooks, fetching them from GIT..."
    for i in "${REPOS[@]}"
	do
		git clone $i
	done
fi
