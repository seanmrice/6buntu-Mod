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
                        sudo cp ./config/sources.list /etc/apt/sources.list
                        sudo add-apt-repository ppa:ubuntu-wine/ppa
                        sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                        sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com DCF9F87B6DFBCBAE F9A2F76A9D1A0061 A040830F7FAC5991 2EBC26B60C5A2783
                        sudo echo "$version" > $upcheck && echo "$time Version update file written successfully" >> $LOG
                        sudo echo "$version \n \l" > ./config/issue && sudo cp ./config/issue /etc/issue && echo "issue successfully updated" && echo "$time issue successfully updated" >> $LOG
                        sudo echo "$version" > ./config/issue.net && sudo cp ./config/issue.net /etc/issue.net && echo "issue.net successfully updated" && echo "$time issue.net successfully updated" >>$LOG
                    else
                        echo "$time 6buntu is up-to-date!" >> $LOG
                fi
            else
                sudo chmod 1775 /etc/6buntu
                sudo echo "$version" > $upcheck && echo "$time upcheck successfully completed" >> $LOG
                sudo echo "$version \n \l" > ./config/issue && sudo cp ./config/issue /etc/issue && echo "issue successfully updated" && echo "$time issue successfully updated" >> $LOG
                sudo echo "$version" > ./config/issue.net && sudo cp ./config/issue.net /etc/issue.net && echo "issue.net successfully updated" && echo "$time issue.net successfully updated" >>$LOG
                exit 300
        fi
    else
        sudo cp ./config/sources.list /etc/apt/sources.list
        sudo add-apt-repository ppa:ubuntu-wine/ppa
        sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com DCF9F87B6DFBCBAE F9A2F76A9D1A0061 A040830F7FAC5991 2EBC26B60C5A2783
        sudo mkdir /etc/6buntu && sudo chmod 1775 /etc/6buntu && sudo echo "$version" > $upcheck && echo "$time Successfully created upcheck file" >> $LOG
        sudo echo "$version \n \l" > ./config/issue && sudo cp ./config/issue /etc/issue && echo "issue successfully updated" && echo "$time issue successfully updated" >> $LOG
        sudo echo "$version" > ./config/issue.net && sudo cp ./config/issue.net /etc/issue.net && echo "issue.net successfully updated" && echo "$time issue.net successfully updated" >>$LOG
fi
exit 0
