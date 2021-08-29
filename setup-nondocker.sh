set -e

alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"

echo "Running apt-get update"
apt-get update

for package in htop tmux screen apt-transport-https ca-certificates curl gnupg-agent software-properties-common
do
	apt-get -y install -qq $package >>runres.log 2>>runerr.log
done

echo "Installing NVIDIA Drivers"
apt-get -y install -qq linux-headers-$(uname -r) >>runres.log 2>>runerr.log

distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')

wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin

mv cuda-$distribution.pin /etc/apt/preferences.d/cuda-repository-pin-600

echo "Adding Cuda Key"
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub

echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list

apt-get update

apt-get -y install -qq cuda-drivers >>runres.log 2>>runerr.log

export PATH=/usr/local/cuda-11.1/bin${PATH:+:${PATH}}


echo "Rebooting in 3"
sleep 1
echo "Rebooting in 2"
sleep 1
echo "Rebooting in 1"
sleep 1
echo "Rebooting NOW!"
echo "Just Kidding, Finished..., Running nvidia-smi"
nvidia-smi
#shutdown -r now

echo "Installing additional packages..."
apt-get -y install sudo git vim tmux htop wget graphviz python3-pip
pip3 install torchvision matplotlib pandas wandb graphviz scikit-learn

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/europa1610/vimconfig.git

cp vimconfig/.vimrc ~/.vimrc

BEGINCOMMENT
//Useful packages inside docker-tf-gpu bash
apt-get update
apt-get -y install sudo git vim tmux
pip3 install torchvision

//Configure vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/europa1610/vimconfig.git

//move vimrc to homedir
//open vimrc and do :PluginInstall

//Create new user
// sudo adduser lubos
//Add user to sudo group
// sudo usermod -aG sudo lubos
// Disable pub key auth https://www.simplified.guide/ssh/disable-public-key-authentication
// sudo vim /etc/ssh/sshd_config
// PubkeyAuthentication no
// PasswordAuthentication yes
// sudo systemctl restart sshd
ENDCOMMENT
