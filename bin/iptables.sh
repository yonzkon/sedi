#!/bin/bash
# Shell Script:    set rules for iptables of firewall 
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2013/11/13
# Last Change:     2014/2/11
# Version:         0.3
#   

    # I) - Usage & Variable
usage()
{
    echo "Usage: {iptables.sh \$TABLE ARGS...}"
    echo "Usage: {iptables.sh filter}"
    echo "Usage: {iptables.sh nat \$SUBNET_NET \$INTERNET_DEV}"
    echo "Usage: \$TABLE {filter | nat | mangle | raw | security}"
    echo "Usage: \$SUBNET_DEV {eth0... | wlan0...}"
    echo "Usage: \$SUBNET_NET {10.0.0.0/20}"
    echo "Usage: \$INTERNET_DEV {eth0... | wlan0...}"
}

if test "$1" = ""; then
    usage && exit -1
else
    TABLE="$1"
    SUBNET_NET="$2"
    INTERNET_DEV="$3"
fi

    #II) - iptables.rules
case "$TABLE" in
filter)
        # 1) - flush existing rules & set chain policy setting to DROP
    echo "[+] Flushing existing iptables rules..."
    iptables -F
    iptables -X
    iptables -Z

        # 2) - load connection-tracking modules 
    modprobe ip_conntrack
    modprobe iptable_nat
    modprobe ip_conntrack_ftp
    modprobe ip_nat_ftp

        # 3) - INPUT chain
    echo "[+] Setting up INPUT chain..."
        # 3.1) - default & state tracking rules
    iptables -AINPUT -ilo -jACCEPT
    iptables -AINPUT -s10.0.0.0/8 -jACCEPT
    iptables -AINPUT -mstate --state=INVALID -jDROP
    iptables -AINPUT -mstate --state=ESTABLISHED,RELATED -jACCEPT
        # 3.2) - syn_flood & ddos & anti-spoofing rules
    iptables -AINPUT -ptcp --syn -mconnlimit --connlimit-above=5 -jDROP
    iptables -AINPUT -ptcp --dport=22 --syn -mstate --state=NEW -jACCEPT
    iptables -NINPUT_DEFENSE
    iptables -AINPUT_DEFENSE -ptcp --syn -mlimit --limit=1/sec --limit-burst=1 -jRETURN
    iptables -AINPUT_DEFENSE -picmp -mlimit --limit=3/minute --limit-burst=5 -jRETURN
    iptables -AINPUT_DEFENSE -jDROP
    iptables -AINPUT -jINPUT_DEFENSE
    #iptables -AINPUT -f -mlimit --limit=100/s --limit-burst=100 -jACCEPT
    #iptables -AINPUT -i$SUBNET_DEV ! -s$SUBNET_NET -jDROP
        # 3.3) - ACCEPT rules
    iptables -AINPUT -ptcp --dport=81 --syn -mstate --state=NEW -jACCEPT
    #iptables -AINPUT -ptcp --dport=444 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=3306 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=3690 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=6900 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=5121 --syn -mstate --state=NEW -jACCEPT
    #iptables -AINPUT -ptcp --dport=5122 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=6121 --syn -mstate --state=NEW -jACCEPT
    #iptables -AINPUT -ptcp --dport=6122 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=8086 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -ptcp --dport=8087 --syn -mstate --state=NEW -jACCEPT
    iptables -AINPUT -picmp --icmp-type=echo-request -jACCEPT
    #iptables -AINPUT ! -ilo ! -d255.255.255.255 -jLOG --log-prefix="INPUT DROP DEFAULT: " --log-ip-options --log-tcp-options
        # 3.$) - POliCY
    iptables -PINPUT DROP

        # 4) - OUTPUT chain
    echo "[+] Setting up OUTPUT chain..."
    iptables -POUTPUT ACCEPT

        # 5) - FORWARD chain
    echo "[+] Setting up FORWARD chain..."
    iptables -PFORWARD ACCEPT
        # 5.1) - state tracking rules
    #iptables -AFORWARD -mstate --state=INVALID -jDROP
    #iptables -AFORWARD -mstate --state=ESTABLISHED,RELATED -jACCEPT
        # 5.2) - anti-spoofing rules
    #iptables -AFORWARD -i$SUBNET_DEV ! -s$SUBNET_NET -jLOG --log-prefix="SPOOFED PKT"
    #iptables -AFORWARD -i$SUBNET_DEV ! -s$SUBNET_NET -jDROP
        # 5.3) - ACCEPT rules
    ##iptables -AFORWARD -i$SUBNET_DEV -mstate --state=NEW -jACCEPT
    #iptables -AFORWARD -ptcp --dport=80 --syn -mstate --state=NEW -jACCEPT
    #iptables -AFORWARD -ptcp --dport=3690 --syn -mstate --state=NEW -jACCEPT
    #iptables -AFORWARD -picmp --icmp-type=echo-request -jACCEPT
    #iptables -AFORWARD ! -ilo -jLOG --log-prefix="FORWARD DROP DEFAULT: " --log-ip-options --log-tcp-options
        # 5.$) - POLICY
    #iptables -PFORWARD DROP
;;
nat)
        # 1) - NAT rules
    iptables -tnat -F
    iptables -tnat -X
    iptables -tnat -Z

    echo "[+] Setting up NAT rules"
    iptables -tnat -APOSTROUTING -o$INTERNET_DEV -s$SUBNET_NET -jMASQUERADE
    #iptables -tnat -APREROUTING  -i$INTERNET_DEV -ptcp --dport=80 -jDNAT --to-destination=10.0.0.13:80
    #iptables -tnat -APREROUTING  -i$INTERNET_DEV -ptcp --dport=3690 -jDNAT --to-destination=10.0.0.14:3690
    echo "1" >/proc/sys/net/ipv4/ip_forward
;;
*)
    usage && exit -1
;;
esac

    # III) - iptables-save
iptables-save >/etc/iptables/iptables.rules
