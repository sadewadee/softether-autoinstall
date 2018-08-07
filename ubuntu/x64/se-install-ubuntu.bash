#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
(( EUID != 0 )) && exec sudo -- "$0" "$@"
clear
read -r -p "This will download and compile SoftEther VPN on your server. Are you sure you want to continue? [y/N] " response
case $response in
[yY][eE][sS]|[yY])
printf "\nMaking sure that there are no previous SoftEther downloads/folders in this current directory.\n\n"
cd ~
rm softether* > /dev/null 2>&1
rm -rf vpnserver > /dev/null 2>&1
update-rc.d vpnserver remove > /dev/null 2>&1
rm /etc/init.d/vpnserver > /dev/null 2>&1
printf "\n${RED}build-essential${NC} and ${RED}checkinstall${NC} are required. Installing those now.\n\n"
apt update && apt install checkinstall build-essential -y
printf "\nDownloading last stable release: ${RED}4.27${NC} | Build ${RED}9668${NC}\n\n"
wget -O softether-vpn-4.27.tar.gz https://icoexist.io/mirror/softether/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
tar -xzf softether-vpn-4.27.tar.gz
cd vpnserver
printf "\n${RED}Please press 1 for all the following questions.${NC}\n\n"
sleep 3
make
cd ~
mv ~/vpnserver /usr/local/
chmod 600 /usr/local/vpnserver/* && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
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
update-rc.d vpnserver defaults
printf "\nSoftEther VPN Server should now start as a system service from now on.\n\n"
systemctl start vpnserver
printf "\nNow opening ports 443/TCP, 1194/TCP & 5555/TCP for basic usage.\n\n"
ufw allow 443,1194,5555/tcp
printf "\nDo you plan to use L2TP/IPsec on this server (y/n)?\n\n"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  ufw allow 500,1701,4500/udp
  printf "\nPorts 500/UDP, 1701/UDP & 4500/UDP were opened.\n\nTo check the status of the VPN server, type ${RED}systemctl status vpnserver${NC}\n\nTo manage the server, type ${RED}sudo /usr/local/vpnserver/vpncmd${NC}\n\nYou can also download the SE VPN manager here: http://bit.ly/2v6xmU6\n\n"
else
  printf "\nAlright, no ports for L2TP/IPsec were opened.\n\nTo check the status of the VPN server, type ${RED}systemctl status vpnserver${NC}\n\nTo manage the server, type ${RED}sudo /usr/local/vpnserver/vpncmd${NC}\n\nYou can also download the SE VPN manager here: http://bit.ly/2v6xmU6\n\n"
fi
printf "\nCleaning up...\n\n"
cd ~ && rm softether* > /dev/null 2>&1
printf "\n${RED}Remember${NC} that if you opened ports for L2TP, you'll need to manually enable UFW for the ports to be actively opened. Make sure you've allowed SSH access through your firewall with ${RED}ufw allow ssh${NC} before enabling UFW with ${RED}ufw enable${NC}\n\n"
esac
