## Mac install tools
## 
## Collect User Email
echo "Enter your email address, we will use this in a bit: "
read var_email
echo "Enter your name (ex: first last), we will add this to GIT for you"
read var_name
## Install Brew
if [ ! -f /usr/local/bin/brew ]; then
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
##
#### uninstall homebrew
## ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
##
## Apple failed to see the usefulness of wget, install it
if [ ! -f /usr/local/bin/wget ]; then
   brew install wget
fi
##
## Google SDK
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-152.0.0-darwin-x86_64.tar.gz
tar -xvf google-cloud-sdk-152.0.0-darwin-x86_64.tar.gz

## there are 3 questions when installing gcloud, this handles the first two.
yes Y | yes Y | ./google-cloud-sdk/install.sh
#pickup the new bash_profile settings
source .bash_profile
#add cloud components
yes Y | gcloud components install kubectl
yes Y | gcloud components install docker-credential-gcr

## cleanup the downloaded tar file
rm google-cloud-sdk-*.gz

## note: lines similar to this should be in your .bash_profile
## The next line updates PATH for the Google Cloud SDK.
# source '/Users/dane/google-cloud-sdk/path.bash.inc'
## The next line enables bash completion for gcloud.
# source '/Users/dane/google-cloud-sdk/completion.bash.inc'

## now init google-cloud for your user
gcloud init

## Create some useful helpers
touch .bashrc

# add bashrc to bash_profile so it's easy to bring profiles from linux
echo 'if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi' | tee -a .bash_profile

# add bash-aliases so it's consistent with linux and other aliases you might create
echo 'if [ -f ~/.bash-aliases ]; then
. ~/.bash-aliases
fi' | tee -a .bashrc

echo "alias lh='ls -alh'" | tee .bash-aliases
echo "alias gc='gcloud'" | tee -a .bash-aliases
echo "alias kc='kubectl'" | tee -a .bash-aliases
echo "alias gcfg='gcloud config list'" | tee -a .bash-aliases
echo "alias kprox='kubectl proxy'" | tee -a .bash-aliases
echo "alias gpset='gcloud project set '" | tee -a .bash-aliases
echo "alias gcred='gcloud containers clusters get-credentials '" | tee -a .bash-aliases

## install postman
brew install Caskroom/cask/postman
brew install Caskroom/cask/pycharm-ce
brew install mongo
brew install mysql
brew install Caskroom/cask/virtualbox
# python3 includes pip3
brew install python3
echo "alias python='python3'" | tee -a .bash-aliases
echo "alias pip='pip3'" | tee -a .bash-aliases
brew install git
brew install docker docker-compose docker-machine
brew install boot2docker
boot2docker init
boot2docker up
eval "$(boot2docker shellinit)"`


git config --global user.email "$var_email"
git config --global user.name "$var_name"

## You have to add your computer to GITHUB via SSH keys
## You should do this manually
ssh-keygen -t rsa -b 4096 -C "$var_email"
eval "$(ssh-agent -s)"
echo "Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa" | tee -a ~/.ssh/config

#install mysql workbench
wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.9-osx-x86_64.dmg ~/Downloads

source .bash_profile
