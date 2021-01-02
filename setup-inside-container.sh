set -e
#Useful packages inside docker-tf-gpu bash
apt-get update
apt-get -y install sudo git vim tmux htop wget
pip3 install torchvision matplotlib pandas wandb

#//Configure vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/europa1610/vimconfig.git

cp vimconfig/.vimrc ~/.vimrc

if [ ]; then
//Create new user
// sudo adduser lubos
//Add user to sudo group
// sudo usermod -aG sudo lubos
// Disable pub key auth https://www.simplified.guide/ssh/disable-public-key-authentication
// sudo vim /etc/ssh/sshd_config
// PubkeyAuthentication no
// PasswordAuthentication yes
// sudo systemctl restart sshd
fi
