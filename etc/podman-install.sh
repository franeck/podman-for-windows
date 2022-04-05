#!/bin/bash

### CUSTOMIZE AREA ###

WINDOWS_HOME=/mnt/c/Users/Jhon
LINUX_HOME=/home/jhon

exit 1 # TODO remove this when finished customizing

#### END ###

NAME=xUbuntu
VERSION_ID=20.04

printf "\n>> STARTING INSTALLATION\n"

printf ">> Installing podman..\n"

sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/${NAME}_${VERSION_ID}/Release.key -O Release.key
apt-key add - < Release.key
apt-get update -qq
apt-get -qq -y install podman
mkdir -p /etc/containers
echo -e "[registries.search]\nregistries = ['docker.io', 'quay.io']" | tee /etc/containers/registries.conf

printf ">> Podman installed\n"

printf ">> Customizing podman..\n"

mkdir -p $HOME/.config/containers
podman info > $HOME/.config/containers/libpod.conf
sed -i 's/eventLogger: file/eventLogger: <file>/' $HOME/.config/containers/libpod.conf

printf ">> Podman customized\n"

printf ">> Adding users..\n"

groupadd podman -g 2000
useradd podman -u 2000 -g 2000
usermod -a -G podman $USER

printf ">> Users added\n"

printf ">> Writing service..\n"

cp conf /etc/init.d/podman
chmod a+x /etc/init.d/podman

printf ">> Service written\n"

printf ">> Starting service..\n"
service podman start
printf ">> Service started\n"



printf ">> Installing ssh..\n"
apt-get -qq -y install openssh-server
ssh-keygen -A
service ssh start
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
service ssh restart
printf ">> Ssh installed\n"

printf ">> Creating ssh keys..\n"
ssh-keygen -b 2048 -t rsa -f $WINDOWS_HOME/.ssh/id_rsa_localhost -q -N ""
mkdir -p $LINUX_HOME/.ssh
cat $WINDOWS_HOME/.ssh/id_rsa_localhost.pub >> $LINUX_HOME/.ssh/authorized_keys
printf ">> Ssh keys created..\n"

printf ">> Adding job..\n"

tee -a /etc/sudoers.d/01-services.conf << END
%sudo   ALL(ALL) NOPASSWD: /usr/sbin/service ssh start
%sudo   ALL(ALL) NOPASSWD: /usr/sbin/service podman start
END

tee -a /etc/wsl-init << END
#!/bin/sh
echo booting
service ssh start
service podman start
END
chmod +x /etc/wsl-init

printf ">> Job added\n"

printf "\n>> INSTALLATION FINISHED !\n"
