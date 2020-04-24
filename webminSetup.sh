#!/bin/bash

####################################################
## Functions                                      ##
####################################################

function detectroot(){
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
}

function updistro(){
   apt update -qq -o Dpkg::Use-Pty=0  && apt upgrade -y -qq -o Dpkg::Use-Pty=0 && apt autoremove -y -qq -o Dpkg::Use-Pty=0
}

function downloadwebmin(){
touch /etc/apt/sources.list.d/webmin.list
echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
echo 'deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
# cat /etc/apt/sources.list.d/webmin.list
curl http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
echo
apt update -qq -o Dpkg::Use-Pty=0
apt install webmin -y -qq -o Dpkg::Use-Pty=0
}

function spin(){
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 1
    done
  done
}

function hostnameset(){

HTNAME=$(hostname)
DOMAIN_SET=gridger.com                 # Default Domain Name for this setup.
DOMAIN_ANSWER=${HTNAME#*.}             # Request actual domain name.
DEVICENAME=${HTNAME/.${HTNAME#*.}/}    # Request device name. 

# echo "Hostname: $HTNAME"               # Print Hostname
# echo "Domain: $DOMAIN_ANSWER"          # Deletes shortest match of $substring from front of $string
# echo "Devicename: $DEVICENAME"

if [ "$DOMAIN_ANSWER" != "$DOMAIN_SET" ]
then
    echo "Changing Hostname..."
    echo "Actual Hostname: "$HTNAME
    NEWNAME=$DEVICENAME"."$DOMAIN_SET
    echo "New Hostname:    "$NEWNAME
    echo
    hostnamectl set-hostname $NEWNAME
    HTNAME=$(hostname)
    # echo $HTNAME
    sleep 5
else
    echo "Actual Hostname: "$HTNAME
    echo "FQDN is correct !!!"
    echo
    sleep 5
fi

# hostnamectl set-hostname demo.gridger.com
}

####################################################
## Body Script                                    ##
####################################################

# CHECK 0: Dectect Root User
detectroot
spin &      # Start the Spinner
SPIN_PID=$! # Make a note of its Process ID (PID)

# CHECK 1: Set a correctly Fully Qualified Domain Name
clear
echo "CHECK 1: Verify a correctly Fully Qualified Domain Name"
echo
hostnameset

# Step 1: Updating Repository
clear
echo "STEP 1: Updating Repository..."
echo
updistro

# Step 2: Downloading Webmin
clear
echo "STEP 2: Downloading Webmin..."
echo
downloadwebmin

# Step 3: Finishing Script
kill -19 $SPIN_PID # Stop Spinner
clear
echo "STEP 3: Finishing Script..."
echo
echo "Webmin install complete. You can now login to https://$HTNAME:10000/"
echo "as root with your root password, or as any user who can use sudo"
echo "to run commands as root."
echo
echo 'Setup done !!!'
echo 