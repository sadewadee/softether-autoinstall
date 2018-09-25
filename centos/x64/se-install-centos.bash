#!/bin/bash

# Define console colors
RED='\033[0;31m'
NC='\033[0m' # No Color
(( EUID != 0 )) && exec sudo -- "$0" "$@"
clear

# User confirmation
read -r -p "This will install SoftEther to your server. Are you sure you want to continue? [y/N] " response
case $response in
[yY][eE][sS]|[yY])

# Create & CD into working directory
printf "\nMaking sure that there are no previous SoftEther downloads/folders in this current directory.\n\n"
cd ~ && rm -rf se-vpn > /dev/null 2>&1
cd ~ && mkdir se-vpn && cd se-vpn
rm /etc/init.d/vpnserver > /dev/null 2>&1

# Install Development Tools & kernel-devel
printf "\n${RED}Development Tools${NC} are required. Installing those now.\n\n"
yum update -y && yum groupinstall "Development Tools" -y && yum install kernel-devel -y

# Download SoftEther | Version 4.27 | Build 9668
printf "\nDownloading last stable release: ${RED}4.27${NC} | Build ${RED}9668${NC}\n\n"
curl -o softether-vpn-4.27.tar.gz https://icoexist.io/mirror/softether/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
tar -xzf softether-vpn-4.27.tar.gz
cd vpnserver
printf "\n${RED}Please press 1 for all the following questions.${NC}\n\n"
sleep 2
echo $'1\n1\n1' | make
cd ~/se-vpn
mv vpnserver/ /usr/local/
chmod 600 /usr/local/vpnserver/* && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver

# Init script
echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver

printf "\nSystem daemon created. Registering changes...\n\n"
chmod 755 /etc/init.d/vpnserver
chkconfig --add vpnserver
printf "\nSoftEther VPN Server should now start as a system service from now on.\n\n"

# Open ports for SoftEther VPN Server using firewalld
printf "\nNow opening ports for SSH and SoftEther.\n\nIf you use another port for SSH, please run ${RED}firewall-cmd --zone=public --add-port=x/tcp${NC} where x = your SSH port.\n\n"
echo '<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>sevpn</short>
  <description>SoftEther VPN Server</description>
  <port protocol="tcp" port="443"/>
  <port protocol="tcp" port="1194"/>
  <port protocol="tcp" port="5555"/>
  <port protocol="tcp" port="992"/>
  <port protocol="udp" port="500"/>
  <port protocol="udp" port="1701"/>
  <port protocol="udp" port="4500"/>
</service>' > /etc/firewalld/services/sevpn.xml
firewall-cmd --reload
firewall-cmd --zone=public --permanent --add-service=sevpn
firewall-cmd --zone=public --permanent --add-service=ssh
firewall-cmd --reload
systemctl start vpnserver
printf "\nCleaning up...\n\n"
cd ~ && rm -rf se-vpn/ > /dev/null 2>&1
systemctl status vpnserver
printf "\nIf the output above shows vpnserver.service to be active (running), then SoftEther VPN has been successfully installed and is now running.\nTo configure the server, use the SoftEther VPN Server Manager located here: https://bit.ly/2NFGNWa\n\n"
esac
