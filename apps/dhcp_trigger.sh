#!/bin/bash
# Dnsmasq passes action ($1), MAC ($2), and IP ($3) automatically
ACTION=$1
MAC=$2
IP=$3

# Only trigger the compiler when a phone creates a fresh "add" or "old" lease
if [ "$ACTION" = "add" ] || [ "$ACTION" = "old" ]; then
    # Force the python engine to compile the MAC non-interactively
    python3 /var/www/oscm/oscm_generator.py --mac="$MAC" --ip="$IP" --auto
fi
