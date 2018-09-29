# ProxyBoxy
ProxyBoxy Configuration Files

This repository holds the configuration files and scripts used in the CactusCon 2018 talk "Weaponizing Your Pi" for the ProxyBoxy Raspberry Pi 3B using a USB Modem, Stegranography, and Reverse SSH tunnels to allow connections into your Pi.

# Requirements
- USB Modem - Hauwei E3372h-510 Unlocked was used for the demo. 
   https://www.amazon.com/E3372-510-Unlocked-150Mbps-Caribbean-External/dp/B01N6P3HI2
- A SIM card - I used Ting https://ting.com/.
- Kali Linux - Latest version https://www.kali.org/downloads/.
- Stegranography - https://github.com/RobinDavid/LSB-Steganography.
- Cloud Server - I used a Digital Oceans droplet for the demo.

# Files
- usb_modeswitch.conf

   The usb_modswitch.conf file is used to switch the USB modem from storage to modem.  Place this file in your /etc/ folder
- gprs 

   The gprs file is used to create your ppp device used by your interfaces file to bring your modem up. Place this file in your /etc/ppp/peers/ folder.
   
- interfaces

   Add the code in the interfaces file to the end of your /etc/network/interfaces file.
   
- tunnel_user_create.sh
   
   This bash script in conjunction with rules.txt is used to create a non-privleged tunnel user for your SSH reverse tunnel on the cloud server of your choice.  You must have a privileged user's (such as root) private key and the IP of the server to execute the script. If you have issues, just read the comments in the file.. its not much. 
   
   USAGE: *>tunnel_user_create.sh 1.2.3.4 id_rsa.privatekey*

- rules.txt

   The rules.txt are the set of permissions imposed on the tunnel user created by tunnel_user_create.sh. 

- connect.sh

   This bash script checks for internet connection, downloads the two images specified for the key and IP, decodes the data from the key and IP images and stores them in /tmp folder, then executes a reverse shell connection using the tmp key and IP with user 'tunnel'.  The file can be executed on boot using /etc/rc.local with the line '/bin/sh /path/to/connect.sh'. *NOTE: there are some hard-coded file locations for the Stegranography portion, just change it...* 
   
- LSBSteg.txt.py

  I modified the orginal LSBSteg.py driver to include text encoding/decoding for our IP and RSA key.  Place it inside your LSB-Steganography folder from the requirements section. 
  
# Config

1. Create/Add files usb_modeswitch.conf, gprs, and interfaces to your Kali instance.  Reboot the system and connect the USB modem, you should see a PPP interface and a route to 192.168.8.1, this is your cable modem.  You can goto 192.168.8.1 in your browser to verify that the cable modem is connected or just ping 8.8.8.8.  

2. Download and install LSB-Steganography from github https://github.com/RobinDavid/LSB-Steganography.  Add the text encoder LSBSteg.txt.py and verify it works with decoding/encoding a couple PNG images. 

3. Place connection.sh in your root folder and update the LSB-Steganography hardcoded locations. 

4. If you have your cloud server running and have gererated your private key to access it, then use the tunnel_user_create.sh script in conjunction with rules.txt to create your tunnel user on your cloud server. *NOTE: do not set a password when requested by tunnel_user_create.sh, just hit enter and move on*

5. Choose two PNGs that you would like to use for your IP and PRIVATE KEY for your tunnel user, then use LSBSteg.txt.py to encode both images and upload them to a image hosting site, such as 24hr.rip.  Copy the location of the files from the image host and update connection.sh's IMG_key and IMG_IP values. 

6. Execute connection.sh and read the output, if successful, you should see the images downloaded via wget, decoded output, and a messages asking you to verify the tunnel on port 2224 on your cloud server.  You can use a local system for testing if you do not have a cloud host to work with. 

 
# Boot

To execute at boot, add the following line to /etc/rc.local.  If you dont have rc.local, create it. 

*/bin/sh /root/connection.sh*
