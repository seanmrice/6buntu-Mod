#!/bin/bash
# Script written by Sean Rice
# The variable cp stands for "Core Packages", dp stands for "Desktop Packages", and up stands for "Unnecessary Packages"
# Core Packages should be installed regardless of the installation
# Desktop Packages are optional and should only be installed on Ubuntu Desktop, not Server (command-line only)
# Log location = /home/<username>/6buntu-LOG.log

######################################## DO NOT MODIFY THIS AREA ########################################################
version="6buntu 1.4"
dp="wine google-chrome-stable aide chkrootkit cpudyn flashplugin-installer compiz-fusion-plugins-extra compizconfig-settings-manager ubuntu-restricted-extras gnome-themes-more"
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
sudo apt-get -f -y update
# Executing installation block
echo "Would you like to start your 6buntu Modification Install?"
echo -n "[Y]es or no: "
read line
echo "Would you like to install the Desktop Packages?"
echo -n "[Y]es or no: "
read line2
if [ "$line" = yes -o Y ]
then
    read -p "$USER, I am installing Core Packages: $cp"; sudo apt-get install -y $sp
    if [ "$?" = 0 ]
        then
            echo "Core Packages Installed Successfully"
            echo date >> $LOG
            echo "Core Packages Installed Successfully" >> $LOG
            sudo cp ./config/hostname /etc/hostname
        else
            read -p "$USER, something went wrong! Please try the installation again"
            echo "Core Packages Installation error, please use: sudo apt-get -f install to correct the problem and then retry the installation" >> $LOG
            exit 500  #Error 500 means Core Packages Installation Failure#
    fi
    if [ "$line2" = yes ]
        then
            read -p "$USER, I am installing Desktop Packages: $dp"; sudo apt-get install -y $dp
            if [ "$?" = 0 ]
                then
                    echo "$USER, I have successfully installed all necessary packages."
                else
                    read -p "$USER, something went wrong! Please try the installation again"
                    date >> $LOG
                    echo "Desktop Packages Installation error, please use: sudo apt-get -f install to correct the problem and then retry the installation" >> $LOG
                    exit 501  #Error 501 means Desktop Packages Installation Failure#
            fi
        else
            echo "Desktop Packages skipped!  If this is incorrect, restart the installation and read the prompts more carefully."
            echo "Desktop Packages skipped!  If this is incorrect, restart the installation and read the prompts more carefully." >> $LOG
    fi
    read -p "Please press Enter to continue"
    sudo gconftool-2 --type=string --set /desktop/gnome/background/picture_filename "./config/Galaxy.png"
    sudo gconftool-2 --type=string --set /desktop/gnome/background/picture_options "zoom"
    sudo gconftool-2 --type=boolean --set /desktop/gnome/remote_access/require_encryption "1"
    sudo gconftool-2 --type=string --set /apps/gnome-session/options/splash_image "./config/6-splash.png"
    sudo gconftool-2 --type=string --set /apps/compiz/general/allscreens/options/active_plugins "core,cpp,move,resize,place,decoration,workarounds,mousepoll,text,imgjpg,regex,dbus,svg,gnomecompat,png,crashhandler,thumbnail,loginout,animation,blur,wobbly,cube,animationaddon,3d,rotate,scale,cubeaddon,expo,ezoom,bench"
# Updating the system and building necessary dependencies
    sudo apt-get dist-upgrade -y
    sudo apt-get build-dep -y openssh miredo
    echo "$version" > ./config/issue.net
    sudo cp ./config/issue.net /etc/issue.net
# Configuring Miredo IPv6 Teredo Tunnelling
    sudo cp ./config/miredo.conf /etc/miredo.conf
# Configuring SSH Server and restarting it
    sudo cp ./config/sshd_config /etc/ssh/sshd_config
    sudo cp ./config/ssh_config /etc/ssh/ssh_config
    if [ ! -e ~/.ssh/id_rsa ]
        then 
            ssh-keygen -t rsa
        else
            echo "SSH keys already exist!  Continuing installation!"
    fi
    sudo /etc/init.d/ssh restart
# Restarting networking to load Miredo and obtain an IPv6 address
    sudo /etc/init.d/networking restart
# Configuring and restarting Denyhosts
    sudo cp ./config/denyhosts.conf /etc/denyhosts.conf
    sudo /etc/init.d/denyhosts restart
# Removing games and unnecessary applications
    sudo apt-get autoremove -y "$games" "$up"
# Cleaning up unnecessary packages
    sudo apt-get autoremove -y
    sudo apt-get update
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
# Rebooting system to finish install
read -p "Hit Enter to reboot the system to complete the install"
sudo reboot -q
exit 0
