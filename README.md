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