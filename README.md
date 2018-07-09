# SoftEther Autoinstaller

This is my SoftEther autoinstaller. This will compile and install SoftEther onto your server. This installer in particular will set up SoftEther as a system service. Currently Ubuntu and CentOS are supported.

### Ubuntu
#### 64-bit
`wget -O install https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/ubuntu/x64/se-install-ubuntu.bash && chmod 777 install && ./install`

#### 32-bit
`wget -O install https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/ubuntu/x86/se-install-ubuntu-x86.bash && chmod 777 install && ./install`

### Prerequisites

It's always nice to have an up-to-date system, however the autoinstaller will attempt to do this for you. ~~Please make sure you run this script with sudo if you are not root.~~ The scripts will automatically require you to authenticate with sudo.

### We're not done here!

This readme will be updated as soon as I have the time to get further into GitHub. For now, I've literally just started and I'm still messing with things. Please don't hurt me.
