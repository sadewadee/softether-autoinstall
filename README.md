# SoftEther Autoinstaller

This is my SoftEther autoinstaller. This will compile and install SoftEther onto your server. This installer in particular will set up SoftEther as a system service. Currently Ubuntu and CentOS are supported.

## Ubuntu 16.04+
### 64-bit
```bash
wget -O install https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/ubuntu/x64/se-install-ubuntu.bash && chmod 770 install && ./install
```

### 32-bit
```bash
wget -O install https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/ubuntu/x86/se-install-ubuntu-x86.bash && chmod 770 install && ./install
```
Please bear in mind that running 32-bit versions of Ubuntu server is not recommended, and Ubuntu 18.04 is **not** available in a 32-bit version.

## CentOS
### 64-bit
```bash
curl -o install https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/centos/x64/se-install-centos.bash && chmod 770 install && ./install
```

### 32-bit
[WIP]

## Configure SoftEther
### Execute vpncmd
To execute SoftEther's cmd utility, use `sudo /usr/local/vpnserver/vpncmd` <-- This applies if you used my scripts. If you've installed SE yourself, find the vpnserver directory.

With `vpncmd` you are able to change every option in regard to SoftEther. It has the same exact purpose for the GUI version you can obtain on MacOS and Windows. I encourage people to use `vpncmd` because it can be easier than the GUI, plus there's no need to download anything since you can configure the entire server from an SSH session.

### Set a server password
It is important that you set a server password. This should be the first thing you do after launching the `vpncmd` utility. To set a password, type `serverpasswordset` into your terminal after you've launched the `vpncmd` utility. For verification, you have to type the password twice.

### Quick-start Guide
This section will provide you with a list of things to get you started with your VPN server. I'll have more commands listed below this section.

1. Start the `vpncmd` utility with `sudo /usr/local/vpncmd`
2. Set a server password with `serverpasswordset`
3. Select the DEFAULT hub with `hub default`
4. Create a new user with `usercreate` | You can either use `usercreate` or `usercreate [uesrname]`
5. Set a password for the new user with `userpasswordset` | You can either use `userpasswordset` or `userpasswordset [uesrname]`
6. Enable SecureNAT for the DEFAULT hub with `securenatenable`

   Optional: You can enable L2TP/IPsec with `ipsecenable`. It is recommended that if you use this option, you only enable L2TP/IPsec. Do not enable RAW L2TP w/o encrpytion. You will be asked to set a pre-shared key for the IPsec server, you can use anything. I've used `vpn` as a pre-shared key for ages. Remember that this is NOT a password for the server or a user, so it's safe to use that. You'll also be asked for the default hub in the event that a user does not specify the hub to connect to in their username, you'll set this to `default` if you haven't changed any hub names. If you're more advanced user and have multiple hubs, you can specify what hub a user connects to by putting it in their username on the client. For instance `icoexist@public` or `icoexist@hub2`.
   
If everything was done properly, you're ready to use your new VPN server! To add new users, just launch the `vpncmd` utility and repeat steps 3 - 5.

### Commands List
#### Entire Server
`about` - Displays the version information   
`serverinfoget` - Displays server information   
`serverstatusget` - Displays the current server status   
`listenercreate` - Creates a new TCP listener on a specified port   
`listenerdelete` - Deletes a TCP listener on a specified port   
`listenerlist` - Displays the current TCP listeners   
`listenerenable` - Starts a TCP listener   
`listenerdisable` - Stops a TCP listener   
`serverpasswordset` - Sets a password for the VPN server   
`clustersettingget` - Displays clustering configuration of the VPN server   
`clustersettingstandalone` - Sets the VPN server type as Standalone   
`clustersettingcontroller` - Set VPN server type as cluster controller

   `/weight` `/only`