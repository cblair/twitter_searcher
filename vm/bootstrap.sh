#!/usr/bin/env bash

## Aditional system tools
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y nodejs

# sudo apt-get install -y imagemagick
# sudo apt-get install -y libsqlite3-dev sqlite3
sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get -y install vim

# Install and configure MySQL Server
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y debconf-utils
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password MySuperPassword'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password MySuperPassword'
sudo apt-get install -y mysql-server

## Install rbenv and rbenv-build to manage ruby environment
su - vagrant -c "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
su - vagrant -c "echo 'export PATH=\"~/.rbenv/bin:$PATH\"' >> ~/.bash_profile"
su - vagrant -c "echo 'eval \"\$(rbenv init -)\"' >> ~/.bash_profile"
su - vagrant -c "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"

## Install Ruby
su - vagrant -c "rbenv install 2.3.0"
su - vagrant -c "rbenv global 2.3.0"
su - vagrant -c "rbenv rehash"

# Install bundler
su - vagrant -c "gem install bundler"
su - vagrant -c "rbenv rehash"

## Install Rails
su - vagrant -c "gem install rails -v 4.2.6"
su - vagrant -c "rbenv rehash"

## Install Node package manager and dependencies
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node # npm expects nodejs to be called node
sudo npm install -g npm # Make sure npm gets updated
sudo npm install -g npm # Run it twice for good measure
su - vagrant -c "cd /vagrant && npm install" # Expects to find an already initialized package.json in the directory

# NOTE: You will need to bundle install and rake db:setup after everything above finishes

# Install postgresql for our rails app.
sudo apt-get install postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser -s vagrant

# Clone the twitter_searcher.
mkdir ~/src/
cd ~/src
https://github.com/cblair/twitter_searcher.git
bundle
rake db:create
rake db:migrate

echo 'Start this rails app with the following to bind to any address (needed for vagrant):'
echo 'rails s -b 0.0.0.0'
