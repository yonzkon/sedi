#!/bin/bash
# Shell Script:    Set files in directory mu with default permission of 0770 at directories and 0660 at normal files!
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2013/10/20
# Last Change:     2013/11/13
# Version:         0.3
#   

export PATH=/sbin/:/bin/:/usr/sbin/:/usr/bin/:/usr/local/sbin/:/usr/local/bin/
export LANG=C

    # I) - reset mu's permission
cd /home/mu/
su -c'chown -R mu:mu ./*' mu
#su -c'find ./ -type d |xargs chmod 0770' mu
#su -c'find ./bin/ -type f |xargs chmod 0770' mu
#su -c'find ./include/ -type f |xargs chmod 0660' mu
#su -c'find ./lib/ -type f |xargs chmod 0640' mu
#su -c'find ./src/ -type f |xargs chmod 0660' mu
#su -c'find ./doc/ -type f |xargs chmod 0660' mu
echo 'process finished successfully!'
exit 0
