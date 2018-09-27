#!/bin/bash

#A script for creating a remote user with only tunnel permissions
#Requires a privileged account on the system you are creating your tunnel account (root) 
#
#Usage: ./script.sh 10.20.30.40 root/private/key/location

#rules.txt : no-agent-forwarding,no-X11-forwarding,command="echo Tunnel Only; exit"


echo "[+] Generating Key... "
ssh-keygen -t rsa -f key

echo "[+] Copying Rules to tunnel.pub..."
cat rules.txt | tr '\n' ' ' > tunnel.pub

echo "[+] Copying key.pub to tunnel.pub..."
cat key.pub >> tunnel.pub

#echo "[+] Verifying rules are in public key..."
#cat tunnel.pub

echo "[+] Copying rules and public key to authorized keys on tunnel server..."
cat ./tunnel.pub | ssh -i $2 root@$1 "mkdir -p /home/tunnel/.ssh && cat >> /home/tunnel/.ssh/authorized_keys"

echo "[+] Validating tunnel key copied and secrure (TunnelOnly)..."
ssh -i key tunnel@$1

echo "[+] Tunnel user creation completed"

echo "[+] Create SSH tunnel on 127.0.0.1:2224:" 
echo "[+]   ssh -i key -N -R 2224:localhost:22 tunnel@$1 "
