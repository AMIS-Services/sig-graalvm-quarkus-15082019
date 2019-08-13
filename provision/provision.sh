#Desktop
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-cache policy docker-ce

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install terminator firefox jq aptitude apt-transport-https ca-certificates gnupg2 curl software-properties-common docker-ce docker-compose libxss1 libgconf2-4 evince socat maven openjdk-8-jdk build-essential libz-dev
aptitude -y install --without-recommends ubuntu-desktop 
#Fix root not allowed to start X-window
xhost local:root

#developer user
useradd -d /home/developer -m developer
echo -e "Welcome01\nWelcome01" | passwd developer
usermod -a -G vboxsf developer
usermod -a -G docker developer
usermod -a -G sudo developer
usermod --shell /bin/bash developer

#Fix screen flickering issue
perl -e '$^I=".backup";while(<>){s/#(WaylandEnable=false)/$1/;print;}' /etc/gdm3/custom.conf

#Hide vagrant
echo '[User]' > /var/lib/AccountsService/users/vagrant
echo 'SystemAccount=true' >> /var/lib/AccountsService/users/vagrant

cp /etc/sudoers.d/vagrant /etc/sudoers.d/developer
sed -i 's/vagrant/developer/g' /etc/sudoers.d/developer

#Install Eclipse
snap install --classic eclipse

#Install GraalVM. Based on https://gist.github.com/ricardozanini/fa65e485251913e1467837b1c5a8ed28
wget https://github.com/oracle/graal/releases/download/vm-19.1.1/graalvm-ce-linux-amd64-19.1.1.tar.gz  -O /tmp/graalvm.tar.gz
tar -xvzf /tmp/graalvm.tar.gz 
mv graalvm-ce-19.1.1 /usr/lib/jvm/
ln -s /usr/lib/jvm/graalvm-ce-19.1.1 /usr/lib/jvm/graalvm
update-alternatives --install /usr/bin/java java /usr/lib/jvm/graalvm/bin/java 1
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/graalvm/bin/javac 1
update-alternatives --install /usr/bin/native-image native-image /usr/lib/jvm/graalvm/bin/native-image 1
update-alternatives --set java /usr/lib/jvm/graalvm/bin/java
update-alternatives --set javac /usr/lib/jvm/graalvm/bin/javac
update-alternatives --set native-image /usr/lib/jvm/graalvm/bin/native-image
rm -f /tmp/graalvm.tar.gz

#Install native image tool
/usr/lib/jvm/graalvm-ce-19.1.1/bin/gu install native-image

#Set GRAALVM_HOME
echo 'export GRAALVM_HOME=/usr/lib/jvm/graalvm' > /etc/profile.d/setGRAALVM_HOME.sh

#Install Minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

#Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt -y install kubectl
apt-get autoremove
apt-get clean

shutdown now -h
