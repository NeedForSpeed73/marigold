#!/bin/bash
#

# Verify Platform
PLATFORM="$(uname -n)"
if [ $PLATFORM == "ubuntugpu" ]; then
	BASE=/mnt/fastdisk
else
	BASE=$HOME
fi

DIR=$BASE/Marigold/workspace
SWAKS_PASS_ID=1volx10osLO2PCuC0Kx3J2rmMijwFTXAs

if [ "$#" -gt 1 ]; then
	printf %"s\n" "Usage: 6_run_marigold.sh <--fast>"
else
	if [ $1 = "--fast" ]; then
		echo "Using LCM (faster) setting."
		python Marigold/run.py --input_rgb_dir $DIR/input --output_dir $DIR/output
	else
		echo "Using DDIM (paper) seting."
		python Marigold/run.py --checkpoint prs-eth/marigold-v1-0 --denoise_steps 50 --ensemble_size 10 --input_rgb_dir $DIR/input/ --output_dir $DIR/output	
	fi
fi

# Send information email
if ! $HOME/gdrive account list > /dev/null 2>&1; then
	$HOME/gdrive account import $HOME/Marigold/gdrive_export-emiliofesocchi_gmail_com.tar > /dev/null 2>&1
fi

PASSWORD="$(cat $HOME/Marigold/swaks.pass)"
if swaks -t emilio.federici@gmail.com --from emiliofesocchi@gmail.com -s smtp.gmail.com:587 -tls -au emiliofesocchi@gmail.com -ap "$PASSWORD" --header "Subject: Marigold Computation Finished" > /dev/null 2>&1; then
		printf %"s\n" "Email successfully sent."
fi
