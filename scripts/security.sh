#!/bin/bash
# This is the security script for 6buntu
# All firewall configuration is done via Uncomplicated Firewall (UFW) commands
# All SSH Configuration is done from configfiles located in ../config
######################################## DO NOT MODIFY THIS AREA ########################################################
version=$(echo | cat ./config/version)
LOG=~/6buntu-LOG.log
time=$(date)
######################################## DO NOT MODIFY THIS AREA ########################################################
# Configuring SSh Server and Client
sudo cp ./config/sshd_config /etc/ssh/sshd_config
sudo cp ./config/ssh_config /etc/ssh/ssh_config
if [ ! -e ~/.ssh/id_rsa ]
    then 
        ssh-keygen -t rsa && echo "$time SSH Keys generated successfully!" >> $LOG
    else
        echo "SSH keys already exist!  Continuing installation!"
        echo "$time SSH keys already exist!  Not generating new keys, and continuing installation" >> $LOG
fi
sudo /etc/init.d/ssh restart
# Configuring UFW for Samba, SSH, and VNC

# John, add the UFW between these two last comments and remove this comment before committing the change.  If you think of any more
# Security features that need to be configured, just make sure to comment on them so I can track changes
exit 0
