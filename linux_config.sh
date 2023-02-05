#!/bin/bash

## Collect some user details
echo ""
echo "This script is intended to assist setting up a linux environment."
echo ""
echo "Please enter your email.  Will use that for GIT and generating an SSH key in a few."

echo "email here: > " 
  read var_email

echo "  Please enter your First Last name"
echo " name here: >" 
  read var_name


echo ""
echo "time to update the OS"

sudo apt-get update
sudo apt-get upgrade -y

# install vim,git and the numlock tool so you can use the numeric keypad on a keyboard
sudo apt-get install vim git numlockx meld -y

echo "alias lh='ls -alh '" | tee -a ~/.bash_aliases

source ~/.bashrc

# set the git user details.
git config --global user.name "$var_email"
git config --global user.name "$var_name"


# ssh stuff
ssh-keygen -t rsa -b 4096 -C "$var_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

echo ""
echo "  This will print out the ssh key for github then wait for you to hit enter."
echo "    copy this key and put it in github under ssh so your machine will talk to it"
echo ""
cat ~/.ssh/id_rsa.pub
echo " .... press enter to continue .... " read var_tmp

# get google cloud sdk
cd ~
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-152.0.0-linux-x86_64.tar.gz
tar -xvf google-cloud-sdk-152.0.0-linux-x86_64.tar.gz
yes Y | yes Y | yes | /google-cloud-sdk/install.sh

source ~/.bashrc

gcloud components install kubectl docker-credential-gcr
gcloud auth application-default login
gcloud init


# install docker
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
    #(lsb_release -cs) \
    #   stable"

sudo apt-get update
sudo apt-get install -y docker-ce

## add user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER


# add a few more aliases
echo "alias gc='gcloud'" | tee -a ~/.bash_aliases
echo "alias kc='kubectl'" | tee -a ~/.bash_aliases
echo "alias gcfg='gcloud config list'" | tee -a ~/.bash_aliases
echo "alias glist='gcloud container clusters list'" | tee -a ~/.bash_aliases
echo "alias gcred='gcloud container clusters get-credentials '" | tee -a ~/.bash_aliases

source ~/.bashrc

echo ""
echo " You need to reboot your machine (sudo reboot) in order to sync perms for docker"
echo "end of script"
