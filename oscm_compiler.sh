#!/usr/bin/env bash
# ====================================================================
#          OSCM — Open Systems Communications Manager
#              Master Modular System Installer v1.0
# ====================================================================
# Description: Clean orchestrator that provisions system environments,
#              seeds the database, deploys external modular files, and
#              injects a live kernel telemetry splash screen.
# Usage:       sudo ./oscm_compiler.sh

set -e

# Target System Directory Mappings
OSCM_DIR="/etc/oscm"
DB_PATH="${OSCM_DIR}/oscm.db"
TFTP_ROOT="/var/ftpd"
NGINX_PROV_ROOT="/var/www/oscm"

# Terminal Formatting Anchors
BLUE="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${BLUE}====================================================================${RESET}"
echo -e "${BLUE}       OSCM — MASTER MODULAR SYSTEM INITIALIZER ENGINE              ${RESET}"
echo -e "${BLUE}====================================================================${RESET}"

# Ensure installer is running with administrative system privileges
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
mkdir -p "${NGINX_PROV_ROOT}/provision/directory"
mkdir -p "${NGINX_PROV_ROOT}/provision/audio"
mkdir -p "${NGINX_PROV_ROOT}/provision/incoming/tmp"
mkdir -p "${NGINX_PROV_ROOT}/dashboard/static"
mkdir -p "${NGINX_PROV_ROOT}/dashboard/backups"

chmod 755 "$TFTP_ROOT"
chown -R www-data:www-data "$NGINX_PROV_ROOT"
chmod -R 755 "$NGINX_PROV_ROOT"

# --------------------------------------------------------------------
# STAGE 3: INITIALIZE STORAGE CONTAINER WITH PRODUCTION SCHEMA
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 3] Building database and forcing WAL safety controls...${RESET}"
sqlite3 "$DB_PATH" <<EOF
PRAGMA journal_mode=WAL;
PRAGMA synchronous=NORMAL;
PRAGMA foreign_keys = ON;

-- 1. ASSET CONTROL MATRIX
CREATE TABLE IF NOT EXISTS assets (
    mac_address TEXT PRIMARY KEY CHECK(length(mac_address) = 12),
    hardware_model TEXT NOT NULL,
    vlan_id INTEGER NOT NULL CHECK(vlan_id IN (1, 2, 100)),
    engine_mode INTEGER NOT NULL CHECK(engine_mode IN (1, 2)), 
    assigned_extension TEXT UNIQUE,
    developer_mode_unlocked INTEGER DEFAULT 1 CHECK(developer_mode_unlocked IN (0, 1)),
    last_sync_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. UNIFIED XML PHONEBOOK DIRECTORY
CREATE TABLE IF NOT EXISTS directory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contact_name TEXT NOT NULL,
    extension_number TEXT NOT NULL UNIQUE,
    display_group TEXT DEFAULT 'OSCM Internal'
);

-- 3. SIDECAR & HARDWARE KEY MAPPING
CREATE TABLE IF NOT EXISTS hardware_keys (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mac_address TEXT NOT NULL,
    key_number INTEGER NOT NULL CHECK(key_number > 0),
    function_string TEXT NOT NULL,
    FOREIGN KEY(mac_address) REFERENCES assets(mac_address) ON DELETE CASCADE,
    UNIQUE(mac_address, key_number)
);

-- 4. MEDIA & CUSTOMIZATION REGISTRY
CREATE TABLE IF NOT EXISTS peripheral_media (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mac_address TEXT NOT NULL,
    wallpaper_filename TEXT DEFAULT 'default.png',
    ringtone_filename TEXT DEFAULT 'ringlist.xml',
    camera_stream_url TEXT DEFAULT NULL,
    FOREIGN KEY(mac_address) REFERENCES assets(mac_address) ON DELETE CASCADE
);

-- SEED DATA: Populate standard network endpoints for initial validation
INSERT OR IGNORE INTO directory (contact_name, extension_number) VALUES 
('OSCM Provisioner Server', '100'),
('VLAN 100 Gateway App', '900'),
('Multicast Intercom Group', '800');
EOF
echo -e "   [+] ${GREEN}Database structuralized successfully with active WAL isolation flags.${RESET}"
# --------------------------------------------------------------------
# STAGE 4: DEPLOY EXTERNAL MODULAR COMPONENT ASSETS
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 4] Injecting modular application files into core paths...${RESET}"

if [ -f "./scripts/oscm_generator.py" ]; then
    cp ./scripts/oscm_generator.py "${OSCM_DIR}/oscm_generator.py"
    chmod +x "${OSCM_DIR}/oscm_generator.py"
    echo -e "   [+] Deployed: ${GREEN}oscm_generator.py${RESET} -> ${OSCM_DIR}"
else
    echo -e "   ${RED}[!] Skipping oscm_generator.py: Module file not found in local staging folder.${RESET}"
fi

if [ -f "./scripts/oscm_backup_repo.sh" ]; then
    cp ./scripts/oscm_backup_repo.sh "${OSCM_DIR}/oscm_backup_repo.sh"
    chmod +x "${OSCM_DIR}/oscm_backup_repo.sh"
    echo -e "   [+] Deployed: ${GREEN}oscm_backup_repo.sh${RESET} -> ${OSCM_DIR}"
else
    echo -e "   ${RED}[!] Skipping oscm_backup_repo.sh: Module file not found in local staging folder.${RESET}"
fi

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

# --------------------------------------------------------------------
# STAGE 5: DYNAMIC TERMINAL & SSH LOGIN SPLASH SCREEN ENFORCEMENT
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 5] Overwriting terminal identity warning structures...${RESET}"

# Clear static legacy text buffers to allow profile shell traps to handle display
> /etc/motd
> /etc/issue.net

# Drop dynamic shell telemetry hook directly into global bash profile initializations
cat << 'EOF' > /etc/profile.d/oscm_splash.sh
#!/usr/bin/env bash
# OSCM Dynamic Telemetry Terminal Splash Engine
if [ -n "$BASH_VERSION" ] && [ "$2" != "noninteractive" ]; then
    SYSTEM_TIME=$(date +"%Y-%m-%d %H:%M:%S %Z")
    VLAN1_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "UNASSIGNED")
    VLAN100_IP=$(ip -4 addr show eth0.100 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "DOWN/DISCONNECTED")
    AST_STATUS=$(systemctl is-active asterisk 2>/dev/null || echo "inactive")
    DNS_STATUS=$(systemctl is-active dnsmasq 2>/dev/null || echo "inactive")

    BLUE="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RESET="\033[0m"
    clear
    echo -e "${BLUE}====================================================================${RESET}"
    echo -e "${BLUE}           OSCM — Open Systems Communications Manager               ${RESET}"
    echo -e "${BLUE}                  Sovereign Network Framework v1.0                  ${RESET}"
    echo -e "${BLUE}====================================================================${RESET}"
    echo -e " [ Temporal Anchor ]  ${YELLOW}${SYSTEM_TIME}${RESET}"
    echo -e " [ Management Network] Interface: ${BLUE}eth0${RESET}       IP: ${GREEN}${VLAN1_IP}${RESET} (VLAN 1)"
    echo -e " [ Telephony Subnet  ] Interface: ${BLUE}eth0.100${RESET}   IP: ${GREEN}${VLAN100_IP}${RESET} (VLAN 100)"
    echo -e " --------------------------------------------------------------------"
    echo -e " [ Core VoIP Engine  ] Asterisk Status:  [ ${GREEN}${AST_STATUS}${RESET} ]"
    echo -e " [ Bootstrap Engine  ] Dnsmasq ZTP Port: [ ${GREEN}${DNS_STATUS}${RESET} ]"
    echo -e "${BLUE}====================================================================${RESET}"
    echo -e " Notice: This communication appliance platform runs strictly on"
    echo -e " native open industry standard network protocols (SIP, DHCP, HTTP,"
    echo -e " TFTP, LLDP-MED). Outbound external data pipelines are firewalled."
    echo -e "${BLUE}====================================================================${RESET}\n"
fi
EOF

chmod 755 /etc/profile.d/oscm_splash.sh
echo -e "   [+] ${GREEN}Dynamic shell telemetry login splash screen deployed to host profiles.${RESET}"

# --------------------------------------------------------------------
# STAGE 6: RELAUNCH MODULAR SYSTEM DAEMONS
# --------------------------------------------------------------------
echo -e "\n${YELLOW}[STAGE 6] Activating infrastructure managers...${RESET}"
systemctl daemon-reload
systemctl restart dnsmasq || true
systemctl restart nginx || true
systemctl restart asterisk || true

echo -e "\n${GREEN}✔️ MODULAR SYSTEM DEPLOYMENT ARCHITECTURE PREP COMPLETE!${RESET}\n"
