/usr/sbin/setenforce 0
sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sudo sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

cat <<EOM | sudo tee -a /etc/yum.repos.d/epel.repo
[epel]
name=epel
baseurl=http://download.fedoraproject.org/pub/epel/6\$basearch
enabled=0
gpgcheck=0
EOM

sudo yum -y install gcc make automake autoconf libtool gcc-c++ kernel-headers-`uname -r` kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget nfs-utils bind-utils
sudo yum -y --enablerepo=epel install dkms

mkdir -pm 700 /home/vagrant/.ssh
# wget --no-check-sertificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
wget --no-check-sertificate 'http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys

chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

cd /tmp
sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt

sudo /etc/rc.d/init.d/vboxadd setup

curl -L https://www.opscode.com/chef/install.sh | sudo bash

