#!/bin/bash
# Shell Script:    Backup daily!
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2013/10/20
# Last Change:     2013/11/02
# Version:         0.2
#   

    # I) - Set environment
export PATH=/sbin/:/bin/:/usr/sbin/:/usr/bin/:/usr/local/sbin/:/usr/local/bin/
export LANG=C

    # II) - Backup configures of system
#cp -p /root/.bash_history /home/linux/etc/.bash_history
#cd /home/ && tar -cjpv --exclude={linux/boot/*,linux/backup/*} -f - linux/ |openssl des3 -salt -k 'sar' -out /home/linux/backup/linux-$(date +%Y_%m_%d).tar.bz2

    # III) - Set permisseion & Backup home of munie
/bin/bash /home/munie/bin/permission.sh
cd /home/ && tar -cjpv --exclude=munie/lost+found \
    --exclude=munie/src/kernel/linux \
    --exclude=munie/src/kernel/linux-stable \
    --exclude=munie/src/kernel/cscope \
    --exclude=munie/src/app/ragnarok \
    --exclude=munie/tmp/backup \
    --exclude=munie/tmp/arm \
    -f - munie/ |openssl des3 -salt -k 'sar' -out /home/munie/tmp/backup/munie-$(date +%Y_%m_%d).tar.bz2

    # $) - Clear old backup files
find /home/munie/tmp/backup/* -mtime +7 -exec rm -rf {} \;
