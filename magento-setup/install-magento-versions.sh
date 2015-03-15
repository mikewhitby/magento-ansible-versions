#!/usr/bin/env bash

# HOW TO USE - run vagrant up first, then cd to the public
# directory on the host o/s and run this

# install all the Magento versions I'm bothered about, set each
# up as a git repo, using a decent gitignore (so you can see if
# you've changed anything), and then install the sample data.
# skips versions that have their directory already present, so
# to reinstall just remove directory and re-run

# an array of versions to install
versions=(1.6.1.0 1.6.2.0 1.7.0.2 1.8.0.0 1.8.1.0 1.9.0.1 1.9.1.0)

# set some required vars
root=`pwd`
parentdir="$(dirname $(readlink -f $0))"

# check we're in the public directory
if [[ ! "$(basename $root)" == "public" ]]; then
	echo "You must run this from the public directory"
	exit 1
fi

# check vagrant is running
if [[ ! `vagrant status` == *"running"* ]]; then
  echo "Vagrant must be running"
  exit 1
fi

# get sample data first (won't download twice if run twice)
bash $parentdir/download-sample-data.sh

# fetch a magento gitignore, and a magento repo (which we use to get all versions)
wget https://gist.githubusercontent.com/mikewhitby/0512c2ce54fea61d8d31/raw/b614106768f90a57171dc806593af3e131b10faf/.gitignore -O magentogitignore
git clone https://github.com/mikewhitby/magento.git

for version in ${versions[*]}; do
	dotlessVersion=${version//./}
	sourceDir="$root/magento"
	targetDir="$root/$dotlessVersion"
	# skip this version if directory already present
	if [ -d "$targetDir" ]; then
		echo "Skipping $version"
		continue
	fi
	# check out the version to install
	cd $sourceDir
	git checkout $version
	# copy it in to a new directory relating to the version, delete if existing
	rm -rf $targetDir
	mkdir $targetDir
	rsync -a --exclude='/.git' $sourceDir/ $targetDir/
	# move in to the directory
	cd $targetDir
	# make a git repo with a gitignore
	cp $root/magentogitignore .gitignore
	git init
	git add -A
	git ci -m "First commit"
	# install with demo data
	vagrant ssh -c "cd /vagrant/public/$dotlessVersion && /vagrant/magento-setup/install-sample-data.sh"
done

# remove the gitignore and the magento repo
rm $root/magentogitignore
rm -rf $root/magento
