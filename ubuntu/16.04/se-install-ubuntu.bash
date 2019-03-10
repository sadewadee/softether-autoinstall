#!/bin/bash
# Define console colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Execute as sudo
(( EUID != 0 )) && exec sudo -- "$0" "$@"
clear

# User confirmation
read -rep $'!!! IMPORTANT !!!\n\nIf you are using this script to upgrade your version of SoftEther, please backup your config file via the GUI manager or copy it from /usr/local/vpnserver/\n\nThis will download and compile SoftEther VPN on your server. Are you sure you want to continue? [y/N] ' response
case $response in
[yY][eE][sS]|[yY])

# Remove previous SoftEther install if available
rm -rf /usr/local/vpnserver /etc/inid.d/vpnserver /tmp/softether-autoinstall > /dev/null 2>&1
update-rc.d vpnserver remove > /dev/null 2>&1

# Create working directory
mkdir -p /tmp/softether-autoinstall
cd /tmp/softether-autoinstall

# Install build-essentials & checkinstall
printf "\n${RED}build-essential${NC} and ${RED}checkinstall${NC} are required. Installing those now.\n\n"
add-apt-repository universe > /dev/null 2>&1
apt update > /dev/null 2>&1
apt install checkinstall build-essential -y

# Download SoftEther | Version 4.27 | Build 9669
printf "\nDownloading release: ${RED}4.29 RTM${NC} | Build ${RED}9680${NC}\n\n"
wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz
tar -xzf softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz
cd vpnserver
echo $'1\n1\n1' | make > /dev/null 2>&1
cd /tmp/softether-autoinstall && mv vpnserver/ /opt
chmod 600 /opt/vpnserver/* && chmod 700 /opt/vpnserver/vpncmd && chmod 700 /opt/vpnserver/vpnserver
cd /tmp/softether-autoinstall && wget -O vpnserver-init https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/vpnserver-init > /dev/null 2>&1
mv vpnserver-init /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver
printf "\nSystem daemon created. Registering changes...\n\n"
update-rc.d vpnserver defaults > /dev/null 2>&1
printf "\nSoftEther VPN Server should now start as a system service from now on.\n\n"
systemctl start vpnserver
printf "\nCleaning up...\n\n"
cd && rm -rf /tmp/softether-autoinstall > /dev/null 2>&1
systemctl status vpnserver
printf "\n${RED}!!! IMPORTANT !!!${NC}\n\nIf the output above shows vpnserver.service to be active (running), then SoftEther VPN has been successfully installed and is now running.\nTo configure the server, use the SoftEther VPN Server Manager located here: http://bit.ly/2D30Wj8 or use ${RED}sudo /opt/vpnserver/vpncmd${NC}\n\n${RED}!!! UFW is not enabled with this script !!!${NC}\n\nTo see how to open ports for SoftEther VPN, please go here: http://bit.ly/2JdZPx6\n\nNeed help? Feel free to join the Discord server: https://icoexist.io/discord\n\n"
esac
