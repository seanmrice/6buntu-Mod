#!/bin/bash
# Script written by Sean Rice
# The variable cp stands for "Core Packages", dp stands for "Desktop Packages", and up stands for "Unnecessary Packages"
# Core Packages should be installed regardless of the installation
# Desktop Packages are optional and should only be installed on Ubuntu Desktop, not Server (command-line only)
# Log location = /home/<username>/6buntu-LOG.log

######################################## DO NOT MODIFY THIS AREA ########################################################
version="6buntu 1.5"
dp="wine google-chrome-stable aide chkrootkit cpudyn flashplugin-installer compiz-fusion-plugins-extra compizconfig-settings-manager simple-ccsm ubuntu-restricted-extras gnome-themes-more k3b gufw"
cp="miredo sun-java6-jdk sun-java6-bin sun-java6-jre sun-java6-fonts 6tunnel automake netcat6 ndisc6 dibbler-client openssh-server denyhosts nmap ssmping openssl preload samba aide chkrootkit cpudyn clamav"
games="gnome-games gbrainy"
up="icedtea6-plugin firefox wide-dhcpv6-client"
LOG=~/6buntu-LOG.log
######################################## DO NOT MODIFY THIS AREA ########################################################

# Saying hello!
echo "Hello $USER, Welcome to $version!"; date
# Configuring sources and updating them
sudo cp ./config/sources.list /etc/apt/sources.list
sudo add-apt-repository ppa:ubuntu-wine/ppa
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com DCF9F87B6DFBCBAE F9A2F76A9D1A0061 A040830F7FAC5991 2EBC26B60C5A2783
sudo apt-get -f -y update
# Executing installation block
echo "Would you like to start your 6buntu Modification Install?  This will install Core Packages."
echo -n "(Yes or no): "
read line
echo "Would you like to install the Desktop Packages?"
echo -n "(Yes or no): "
read line2
if [ "$line" = yes -o Y ]
then
    echo "Starting installation per user request" >> $LOG 
    read -p "$USER, I am installing Core Packages: $cp"; sudo apt-get install -y $sp
    if [ "$?" = 0 ]
        then
            echo "Core Packages Installed Successfully"
            date >> $LOG
            echo "Core Packages Installed Successfully" >> $LOG
            sudo cp ./config/hostname /etc/hostname && date >> $LOG && echo "Hostname configured successfully"
        else
            read -p "$USER, something went wrong! Please try the installation again"
            date >> $LOG
            echo "Core Packages Installation error, please use: sudo apt-get -f install to correct the problem and then retry the installation" >> $LOG
            echo "500" >> $LOG
            exit 500  #Error 500 means Core Packages Installation Failure#
    fi
    if [ "$line2" = yes ]
        then
            read -p "$USER, I am installing Desktop Packages: $dp"; sudo apt-get install -y $dp
            if [ "$?" = 0 ]
                then
                    echo "$USER, I have successfully installed all necessary packages."
                    echo "Desktop Packages Installed Successfully"
                    date >> $LOG
                    echo "Desktop Packages Installed Successfully" >> $LOG
                else
                    read -p "$USER, something went wrong! Please try the installation again"
                    date >> $LOG
                    echo "Desktop Packages Installation error, please use: sudo apt-get -f install to correct the problem and then retry the installation" >> $LOG1
                    echo "501"
                    exit 501  #Error 501 means Desktop Packages Installation Failure#
            fi
        else
            echo "Desktop Packages skipped!  If this is incorrect, restart the installation and read the prompts more carefully."
            date >> $LOG
            echo "Desktop Packages skipped!  If this is incorrect, restart the installation and read the prompts more carefully." >> $LOG
    fi
    read -p "Please press Enter to continue"
# Changing desktop configuration and enabling minor security features for remote desktop
    sudo gconftool-2 --type=string --set /desktop/gnome/background/picture_filename "./config/Galaxy.png"
    sudo gconftool-2 --type=string --set /desktop/gnome/background/picture_options "zoom"
    sudo gconftool-2 --type=boolean --set /desktop/gnome/remote_access/require_encryption "1"
    sudo gconftool-2 --type=string --set /apps/gnome-session/options/splash_image "./config/6-splash.png"
    sudo gconftool-2 --type=string --set /apps/compiz/general/allscreens/options/active_plugins "core,cpp,move,resize,place,decoration,workarounds,mousepoll,text,imgjpg,regex,dbus,svg,gnomecompat,png,crashhandler,thumbnail,loginout,animation,blur,wobbly,cube,animationaddon,3d,rotate,scale,cubeaddon,expo,ezoom,bench"
    if [ "$?" = 0 ]
        then
            echo "Desktop settings configured successfully"
            date >> $LOG
            echo "Desktop settings configured successfully" >> $LOG
        else
            echo "Desktop settings could not be configured properly"
            date >> $LOG
            echo "Desktop settings could not be configured properly"
    fi
# Updating the system and building necessary dependencies
    sudo apt-get dist-upgrade -y
    if [ "$?" = 0 ]
        then
            echo "All system packages upgraded successfully"
            date >> $LOG
            echo "All system packages upgraded successfully" >> $LOG
        else
            echo "There were one or more errors during the system packages upgrade process"
            date >> $LOG
            echo "There were one or more errors during the system packages upgrade process" >> $LOG
    fi
    sudo apt-get build-dep -y openssh miredo && date >> $LOG && echo "Dependencies built successfully for OpenSSH and Miredo"
    echo "$version" > ./config/issue.net
    sudo cp ./config/issue.net /etc/issue.net
# Configuring Miredo IPv6 Teredo Tunnelling
    sudo cp ./config/miredo.conf /etc/miredo.conf && date >> $LOG && echo "Miredo configured successfully"
# Configuring SSH Server and restarting it
    sudo cp ./config/sshd_config /etc/ssh/sshd_config
    sudo cp ./config/ssh_config /etc/ssh/ssh_config
    if [ ! -e ~/.ssh/id_rsa ]
        then 
            ssh-keygen -t rsa && date >> $LOG && echo "SSH Keys generated successfully!" >> $LOG
        else
            echo "SSH keys already exist!  Continuing installation!"
            echo "SSH keys already exist!  Not generating new keys and continuing installation" >> $LOG
    fi
    sudo /etc/init.d/ssh restart
# Restarting networking to load Miredo and obtain an IPv6 address
    sudo /etc/init.d/networking restart
# Configuring and restarting Denyhosts
    sudo cp ./config/denyhosts.conf /etc/denyhosts.conf  && date >> $LOG && echo "Denyhosts has been configured successfully" >> $LOG
    sudo /etc/init.d/denyhosts restart
# Removing games and unnecessary applications
    sudo apt-get autoremove -y "$games" "$up" && date >> $LOG && echo "Unnecessary Packages removed successfully"
# Cleaning up unnecessary packages
    sudo apt-get autoremove -y
    sudo apt-get update
    sleep 3
else
    date >> $LOG
    echo "You chose to exit the installation" >> $LOG
    echo "2" >> $LOG
    exit 2
fi
# Checking for rootkit and virus infections in the background
sudo chkrootkit > ./Rootkit_Scan_Results &
sudo freshclam > ./ClamAV_Results &
if [ -d /infected ]
then
    sudo clamscan -r --move=/infected / >> ./ClamAV_Results &
else
    sudo mkdir /infected
    sudo clamscan -r --move=/infected / >> ./ClamAV_Results &
fi
# Generating 6buntu upcheck file in /etc
if [ -e /etc/6buntu ]
    then
        if [ cat /etc/6buntu/6buntu-upcheck | grep "$version" != "$version" ]
            then
                echo "$version" > /etc/6buntu/6buntu-upcheck && echo "Version update file written successfully" && date >> $LOG && echo "Version update file written successfully" >> $LOG
            else
                echo "6buntu is up-to-date!"
                date >> $LOG && echo "6buntu is up-to-date!" >> $LOG
        fi
    else
        sudo mkdir /etc/6buntu && echo "$version" > /etc/6buntu/6buntu-upcheck && date >> $LOG && echo "Successfully created upcheck file" && echo "Successfully created upcheck file" >> $LOG
fi
# Rebooting system to finish install
read -p "Hit Enter to reboot the system to complete the install"
echo "$USER, the installation has completed successfully" >> $LOG
sudo reboot -f -q
exit 0
