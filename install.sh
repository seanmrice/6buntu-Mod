#!/bin/bash
# Script written by Sean Rice
# The variable sp stands for "Server Packages", dp stands for "Desktop Packages", and up stands for "Unnecessary Packages"
# Server Packages should be installed regardless of the installation
# Desktop Packages are optional and should only be installed on Ubuntu Desktop, not Server (command-line only)
# Error log location = /home/<username>/6buntu-LOG.log
InstallDesktop=yes #Change to "no" if you do not want to install the Graphical User Interface (Desktop) packages

######################################## DO NOT MODIFY THIS AREA ########################################################
dp="wine google-chrome-stable aide chkrootkit cpudyn flashplugin-installer compiz-fusion-plugins-extra compizconfig-settings-manager ubuntu-restricted-extras gnome-themes-more"
sp="miredo sun-java6-jdk sun-java6-bin sun-java6-jre sun-java6-fonts 6tunnel automake netcat6 ndisc6 dibbler-client openssh-server denyhosts nmap ssmping openssl preload samba aide chkrootkit cpudyn clamav"
games="gnome-games gbrainy"
up="icedtea6-plugin firefox"
LOG=~/6buntu-LOG.log
######################################## DO NOT MODIFY THIS AREA ########################################################

# Saying hello!
echo "Hello $USER, Welcome to 6buntu version 1!"; date
# Configuring sources and updating them
sudo cp ./config/sources.list /etc/apt/sources.list
sudo add-apt-repository ppa:ubuntu-wine/ppa
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get -f -y update
# Executing installation block
echo "Would you like to start your 6buntu Modification Install?"
echo -n "[Y]es or no: "
read line
if [ $line = yes -o Y -o y ]
then
    read -p "$USER, I am installing Server packages: $sp"; sudo apt-get install -y $sp 
    if [ "$?" = 0 ]
        then 
            echo "Server Packages Installed Successfully"
            sudo echo "Ricebuntu-Server" > /etc/hostname
        else
            read -p "$USER, something went wrong! Please try the installation again"
            echo "Server Packages Installation error, please use: sudo apt-get -f install to correct the problem and then retry the installation" >> $LOG
            exit 500  #Error 500 means Server Packages Installation Failure#
    fi
# Comment out the following 3 lines if you don't want to install the desktop GUI features (if you are running Server Edition)
    if [ $InstallDesktop = 1 ]
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
            echo "Desktop Packages skipped!  If this is incorrect, change the InstallDesktop variable in the install file to InstallDesktop=1"
            echo "Desktop Packages skipped!  If this is incorrect, change the InstallDesktop variable in the install file to InstallDesktop=1" >> $LOG
    fi
    read -p "Please press Enter to continue"
    sudo gconftool-2 --type=string --set /desktop/gnome/background/picture_filename "./config/Galaxy.png"

# Updating the system and building necessary dependencies
    sudo apt-get dist-upgrade -y
    sudo apt-get build-dep -y openssh bash miredo
# Configuring Miredo IPv6 Teredo Tunnelling
    sudo cp ./config/miredo.conf /etc/miredo.conf
# Configuring SSH Server and restarting it
    sudo cp ./config/sshd_config /etc/ssh/sshd_config
    sudo cp ./config/ssh_config /etc/ssh/ssh_config
    sudo cp ./config/issue.net /etc/issue.net
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
