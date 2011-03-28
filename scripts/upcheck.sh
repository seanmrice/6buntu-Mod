#!/bin/bash
#Upcheck script v0.01
######################################## DO NOT MODIFY THIS AREA ########################################################
version=$(echo | cat ../config/version)
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
                exit 300
        fi
    else
        sudo mkdir /etc/6buntu && sudo chmod 1777 /etc/6buntu && sudo echo "$version" > $upcheck && echo "$time Successfully created upcheck file" >> $LOG
fi
exit 0
