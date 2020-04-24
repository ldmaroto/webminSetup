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

function copycerts(){
    sleep 5
    cp ~/webminSetup/certs/miniserv.pem /etc/webmin/miniserv.pem
    cp ~/webminSetup/certs/miniserv.cert /etc/webmin/miniserv.cert
    cp ~/webminSetup/certs/miniserv.chain /etc/webmin/miniserv.chain
    chmod 600 /etc/webmin/miniserv.*
    chown root:bin /etc/webmin/miniserv.*
}

####################################################
## Body Script                                    ##
####################################################

# CHECK 0: Dectect Root User
detectroot
spin &      # Start the Spinner
SPIN_PID=$! # Make a note of its Process ID (PID)

# CHECK 1: Copying certificates
clear
echo "CHECK 1: Copying certificates"
echo
copycerts

# Step 2: Finishing Script
kill -19 $SPIN_PID # Stop Spinner
clear
echo "STEP 2: Finishing Script..."
echo
echo 'Setup done !!!'
echo 