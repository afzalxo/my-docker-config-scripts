set -e

echo "Running apt-get update"
apt-get update

for package in htop tmux screen apt-transport-https ca-certificates curl gnupg-agent software-properties-common
do
	apt-get -y install -qq $package >>runres.log 2>>runerr.log
done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Adding Docker Repo"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

echo "Installing Docker-CE Docker-CE-CLI and containerd.io"
for package in docker-ce docker-ce-cli containerd.io
do
	echo "Installing $package"
	apt-get install -qq $package >>runres.log 2>>runerr.log
done

echo "Stopping Docker Service"
service docker stop

echo "Moving Docker Data diretory to /mydata/docker-data/"
echo -e "{\n\t \"graph\": \"/mydata/docker-data/\"\n}" | sudo tee -a /etc/docker/daemon.json

rsync -aP /var/lib/docker/ /mydata/docker-data/

mv /var/lib/docker /var/lib/docker.old

echo "Restarting docker daemon"
service docker start

echo "Installing NVIDIA Drivers"
apt-get -y install -qq --print-uris linux-headers-$(uname -r) >>runres.log 2>>runerr.log

distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')

wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin

mv cuda-$distribution.pin /etc/apt/preferences.d/cuda-repository-pin-600

echo "Adding Cuda Key"
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub

echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list

apt-get update

apt-get -y install -qq --print-uris cuda-drivers >>runres.log 2>>runerr.log

export PATH=/usr/local/cuda-11.1/bin${PATH:+:${PATH}}

echo "Rebooting in 3"
sleep 1
echo "Rebooting in 2"
sleep 1
echo "Rebooting in 1"
sleep 1
echo "Rebooting NOW!"
#shutdown -r now

// Installing TF docker image (https://www.tensorflow.org/install/docker)
docker pull tensorflow/tensorflow                     # latest stable release
docker pull tensorflow/tensorflow:devel-gpu           # nightly dev release w/ GPU support
docker pull tensorflow/tensorflow:latest-gpu-jupyter  # latest release w/ GPU support and Jupyter

// Install NVIDIA container toolkit (https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update
apt-get install -y nvidia-docker2
systemctl restart docker

// Test CUDA
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
// Run tf-docker bash shell
#docker run --gpus all -it tensorflow/tensorflow:latest-gpu bash

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
