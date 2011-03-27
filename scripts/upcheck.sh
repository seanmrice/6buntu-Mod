#!/bin/bash
#Upcheck script v0.01
######################################## DO NOT MODIFY THIS AREA ########################################################
version="6buntu 1.5"
dp="wine google-chrome-stable aide chkrootkit cpudyn flashplugin-installer compiz-fusion-plugins-extra compizconfig-settings-manager simple-ccsm ubuntu-restricted-extras gnome-themes-more k3b gufw"
cp="miredo sun-java6-jdk sun-java6-bin sun-java6-jre sun-java6-fonts 6tunnel automake netcat6 ndisc6 dibbler-client openssh-server denyhosts nmap ssmping openssl preload samba aide chkrootkit cpudyn clamav"
games="gnome-games gbrainy"
up="icedtea6-plugin firefox wide-dhcpv6-client"
LOG=~/6buntu-LOG.log
upcheck=/etc/6buntu/6buntu-upcheck
time=$(date)
######################################## DO NOT MODIFY THIS AREA ########################################################
if [ -e /etc/6buntu ]
    then
        if [ -e $upcheck ]
            then
                sudo chmod 1775 /etc/6buntu
                if grep $upcheck -ne "$version" >> /dev/null
                    then
                        sudo echo "$version" > $upcheck && echo "$time Version update file written successfully" >> $LOG
                    else
                        echo "$time 6buntu is up-to-date!" >> $LOG
                fi
            else
                sudo chmod 1775 /etc/6buntu
                sudo echo "$version" > $upcheck && echo "$time upcheck successfully completed" >> $LOG
                exit
        fi
    else
        sudo mkdir /etc/6buntu && sudo chmod 1777 /etc/6buntu && sudo echo "$version" > $upcheck && echo "$time Successfully created upcheck file" >> $LOG
fi
exit 0
