#!/usr/bin/env bash
# ====================================================================
#           OSCM — Open Systems Communications Manager v1.1
#               Dynamic Telemetry Terminal Splash Engine
# ====================================================================

if [ -n "$BASH_VERSION" ] && [ "$2" != "noninteractive" ]; then
    SYSTEM_TIME=$(date +"%Y-%m-%d %H:%M:%S %Z")
    
    # Dynamically scans interfaces for active production leases
    VLAN1_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "UNASSIGNED")
    AST_STATUS=$(systemctl is-active asterisk 2>/dev/null || echo "inactive")
    DNS_STATUS=$(systemctl is-active dnsmasq 2>/dev/null || echo "inactive")

    BLUE="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RESET="\033[0m"
    clear
    echo -e "${BLUE}====================================================================${RESET}"
    echo -e "${BLUE}           OSCM — Open Systems Communications Manager               ${RESET}"
    echo -e "${BLUE}                  Sovereign Network Framework v1.0                  ${RESET}"
    echo -e "${BLUE}====================================================================${RESET}"
    echo -e " [ Temporal Anchor ]  ${YELLOW}${SYSTEM_TIME}${RESET}"
    echo -e " [ System Core IP  ]  Primary Host IP: ${GREEN}${VLAN1_IP}${RESET}"
    echo -e " --------------------------------------------------------------------"
    echo -e " [ Core VoIP Engine  ] Asterisk Status:  [ ${GREEN}${AST_STATUS}${RESET} ]"
    echo -e " [ Bootstrap Engine  ] Dnsmasq ZTP Port: [ ${GREEN}${DNS_STATUS}${RESET} ]"
    echo -e "${BLUE}====================================================================${RESET}"
fi
