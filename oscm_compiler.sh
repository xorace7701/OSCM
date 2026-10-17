#!/usr/bin/env bash
# ====================================================================
#          OSCM — Open Systems Communications Manager
#              Master Modular System Installer v1.2
# ====================================================================
# Description: Lean master orchestrator that provisions directories,
#              compiles database containers via external modular layers,
#              and deploys decoupled configuration templates.
# Usage:       sudo ./oscm_compiler.sh

set -e

# Production System Mount Targets
OSCM_DIR="/etc/oscm"
DB_PATH="${OSCM_DIR}/oscm.db"
TFTP_ROOT="/var/ftpd"
NGINX_PROV_ROOT="/var/www/oscm"

# Unified Terminal ANSI Colors
BLUE="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${BLUE}====================================================================${RESET}"
echo -e "${BLUE}       OSCM — MASTER MODULAR SYSTEM INITIALIZER ENGINE              ${RESET}"
echo -e "${BLUE}====================================================================${RESET}"

# Strict Administrative Privilege Escalation Enforcement Guard
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ SYSTEM FAULT: This compiler layer must be run as root (sudo).${RESET}"
    exit 1
fi

# --------------------------------------------------------------------
# STAGE 1: SYSTEM DEPENDENCY DEPLOYMENT MATRIX
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 1] Syncing system packages and launching daemons...${RESET}"
DEPENDENCIES=(
    "systemd" "asterisk" "nginx" "tftp-hpa" "vsftpd" "dnsmasq" 
    "openlldp" "chrony" "iptables" "sqlite3" "python3" "curl"
    "ifupdown" "vlan" "python3-pip" "python3-flask"
)
apt-get update -y
for pkg in "${DEPENDENCIES[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        echo -e "   [+] ${GREEN}${pkg}${RESET} is already active on this host."
    else
        echo -e "   [+] Installing foundational core module: ${BLUE}${pkg}${RESET}..."
        apt-get install -y "$pkg"
    fi
done


# --------------------------------------------------------------------
# STAGE 2: BUILD STRUCTURED DEVICE FILESYSTEM HIERARCHY
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 2] Building file system node hierarchies...${RESET}"
mkdir -p "$OSCM_DIR"
mkdir -p "$TFTP_ROOT"
mkdir -p "${NGINX_PROV_ROOT}/apps"
mkdir -p "${NGINX_PROV_ROOT}/ui/templates"
mkdir -p "${NGINX_PROV_ROOT}/tftpboot/phone_assets"
mkdir -p "${NGINX_PROV_ROOT}/tftpboot/switch_assets"
mkdir -p "${NGINX_PROV_ROOT}/tftpboot/backup_repo"

chmod 755 "$TFTP_ROOT"
chown -R www-data:www-data "$NGINX_PROV_ROOT"
chmod -R 755 "$NGINX_PROV_ROOT"

# --------------------------------------------------------------------
# STAGE 3: INITIALIZE STORAGE CONTAINER WITH PRODUCTION SCHEMA
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 3] Building database and forcing WAL safety controls...${RESET}"

# 1. Instantiate the database container and enable safe high-speed journaling
sqlite3 "$DB_PATH" "PRAGMA journal_mode=WAL; PRAGMA synchronous=NORMAL; PRAGMA foreign_keys = ON;"

# 2. Compile structural layouts using your offloaded apps/schema.sql matrix
if [ -f "./apps/schema.sql" ]; then
    sqlite3 "$DB_PATH" < "./apps/schema.sql"
    echo -e "   [+] Applied: ${GREEN}schema.sql${RESET} -> Relational container schema active."
else
    echo -e "   ${RED}[!] CRITICAL ERROR: ./apps/schema.sql missing. Cannot compile database.${RESET}"
    exit 1
fi

# 3. Seed validation endpoint lines out of your offloaded apps/seed.sql matrix
if [ -f "./apps/seed.sql" ]; then
    sqlite3 "$DB_PATH" < "./apps/seed.sql"
    echo -e "   [+] Applied: ${GREEN}seed.sql${RESET} -> Default extensions seeded."
else
    echo -e "   ${RED}[!] WARNING: ./apps/seed.sql missing. Skipping system database seeding.${RESET}"
fi

echo -e "   [+] ${GREEN}Database structuralized successfully via modular app layers.${RESET}"
# --------------------------------------------------------------------
# STAGE 4: DEPLOY EXTERNAL MODULAR COMPONENT ASSETS
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 4] Injecting modular application files into core paths...${RESET}"

# INTEGRATED INTERACTIVE IFUPDOWN NETWORKING CONVERSION TERMINAL LAYER
if [ -f "./config/interfaces.conf" ]; then
    cp ./config/interfaces.conf "${OSCM_DIR}/interfaces_selector.sh"
    chmod +x "${OSCM_DIR}/interfaces_selector.sh"
    echo -e "   [+] Deployed script engine: ${GREEN}interfaces.conf${RESET} -> ${OSCM_DIR}"
    
    # Run the interactive network interface prompt immediately for the engineer
    bash "${OSCM_DIR}/interfaces_selector.sh"
else
    echo -e "   ${RED}[!] Skipping network interface setup: Module script not found in local staging folder.${RESET}"
fi

# Deploy the standalone Access Control List (ACL) and Firewall script layer
if [ -f "./config/firewall.conf" ]; then
    cp ./config/firewall.conf "${OSCM_DIR}/firewall_rules.sh"
    chmod +x "${OSCM_DIR}/firewall_rules.sh"
    echo -e "   [+] Deployed: ${GREEN}firewall.conf${RESET} -> ${OSCM_DIR}"
    
    # Execute the modular firewall script instantly to open and lock your system ports
    bash "${OSCM_DIR}/firewall_rules.sh"
else
    echo -e "   ${RED}[!] Skipping firewall lockdown: Module script missing in staging folder.${RESET}"
fi

# Deploy the Python configuration parser script straight to the web root level from scripts folder
if [ -f "./scripts/oscm_generator.py" ]; then
    cp ./scripts/oscm_generator.py "${NGINX_PROV_ROOT}/oscm_generator.py"
    chmod +x "${NGINX_PROV_ROOT}/oscm_generator.py"
    echo -e "   [+] Deployed: ${GREEN}oscm_generator.py${RESET} -> ${NGINX_PROV_ROOT}"
else
    echo -e "   ${RED}[!] Skipping oscm_generator.py: Module file not found in local scripts staging folder.${RESET}"
fi

# Deploy the repository safety backup vault script directly into the tracking directory
if [ -f "./scripts/oscm_backup_repo.sh" ]; then
    cp ./scripts/oscm_backup_repo.sh "${OSCM_DIR}/oscm_backup_repo.sh"
    chmod +x "${OSCM_DIR}/oscm_backup_repo.sh"
    echo -e "   [+] Deployed: ${GREEN}oscm_backup_repo.sh${RESET} -> ${OSCM_DIR}"
else
    echo -e "   ${RED}[!] Skipping oscm_backup_repo.sh: Module file not found in local scripts staging folder.${RESET}"
fi

# Sweep application logic blocks and frontend layouts into place safely
echo -e "   [+] Copying application engine components and front-end blueprints..."
cp ./apps/* "${NGINX_PROV_ROOT}/apps/" || true
cp ./ui/templates/* "${NGINX_PROV_ROOT}/ui/templates/" || true

if [ -f "./config/dnsmasq.conf" ]; then
    cp ./config/dnsmasq.conf /etc/dnsmasq.conf
    echo -e "   [+] Deployed: ${GREEN}dnsmasq.conf${RESET} -> /etc"
else
    echo -e "   ${RED}[!] Skipping dnsmasq.conf: Module file not found in local staging folder.${RESET}"
fi

if [ -f "./config/nginx-oscm.conf" ]; then
    cp ./config/nginx-oscm.conf /etc/nginx/sites-available/nginx-oscm.conf
    ln -sf /etc/nginx/sites-available/nginx-oscm.conf /etc/nginx/sites-enabled/nginx-oscm.conf
    rm -f /etc/nginx/sites-enabled/default || true
    echo -e "   [+] Deployed: ${GREEN}nginx-oscm.conf${RESET} -> /etc/nginx/sites-enabled/"
else
    echo -e "   ${RED}[!] Skipping nginx-oscm.conf: Module file not found in local staging folder.${RESET}"
fi

if [ -f "./config/pjsip.conf" ]; then
    cp ./config/pjsip.conf /etc/asterisk/pjsip.conf
    echo -e "   [+] Deployed: ${GREEN}pjsip.conf${RESET} -> /etc/asterisk"
else
    echo -e "   ${RED}[!] Skipping pjsip.conf: Module file not found in local staging folder.${RESET}"
fi

if [ -f "./config/oscm-web.service" ]; then
    cp ./config/oscm-web.service /etc/systemd/system/oscm-web.service
    echo -e "   [+] Deployed: ${GREEN}oscm-web.service${RESET} -> /etc/systemd/system"
else
    echo -e "   ${RED}[!] Skipping oscm-web.service: Unit layout file missing."
fi

# --------------------------------------------------------------------
# STAGE 5: DYNAMIC TERMINAL & SSH LOGIN SPLASH SCREEN ENFORCEMENT
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 5] Overwriting terminal identity warning structures...${RESET}"

# Clear static text buffers to allow profile shell traps to handle display
> /etc/motd
> /etc/issue.net

# Drop your offloaded script engine straight into global bash profile initializations
if [ -f "./scripts/oscm_splash.sh" ]; then
    cp ./scripts/oscm_splash.sh /etc/profile.d/oscm_splash.sh
    chmod 755 /etc/profile.d/oscm_splash.sh
    echo -e "   [+] ${GREEN}Dynamic shell telemetry login splash screen deployed to host profiles.${RESET}"
else
    echo -e "   ${RED}[!] Skipping splash setup: Module script missing in scripts folder.${RESET}"
fi

# --------------------------------------------------------------------
# STAGE 6: RELAUNCH MODULAR SYSTEM DAEMONS
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 6] Activating infrastructure managers...${RESET}"
systemctl daemon-reload
systemctl enable oscm-web.service || true
systemctl restart oscm-web.service || true
systemctl restart dnsmasq || true
systemctl restart nginx || true
systemctl restart asterisk || true

echo -e "\n${GREEN}✔️ MODULAR SYSTEM DEPLOYMENT ARCHITECTURE PREP COMPLETE!${RESET}\n"
