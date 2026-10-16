
🛰️ Project Summary & Mission Statement: OSCM v1.0

OSCM (Open Systems Communications Manager) is an open-source appliance platform built to support global e-waste reduction, hardware sustainability, and accessible network education.
While the platform's primary development focus and baseline testing matrix are optimized for Linksys/Cisco SPA962, Cisco SPA525G, Cisco 7900 series, and Cisco 8800 series VoIP endpoints, Linksys SPA3102 voice gateways, and Cisco SRP500 series routing silicon, its core architecture is built entirely upon universal, open-standard network protocols. Because OSCM relies strictly on native industry standards—such as RFC-compliant SIP, DHCP, HTTP, TFTP, and vendor-neutral LLDP-MED—the platform remains inherently compatible with open-SIP endpoints, managed switches, and network assets from any manufacturer that adheres to standard networking behaviors. OSCM provides a welcoming, well-documented framework that simplifies the configuration and reuse of these devices using their factory-default software settings, ensuring that excellent hardware remains a valuable asset for learning and local communication without proprietary gatekeeping.

📦 Core OS Project Dependencies

To maintain a lean footprint without duplicating proven architectures, OSCM coordinates and links into the following native open-source project cores as its foundational daemon dependency layers:
• Linux Server Core: Host operating system framework and system initialization daemon (systemd).
• Asterisk (VoIP Engine Core): Processes standard RFC-compliant Session Initiation Protocol (SIP/PJSIP) channels, registration lookups, media streams, and voicemails.
• Nginx with WebDAV Subsystem: Distributes configuration payloads, streams audio ringtones, and handles incoming HTTP PUT requests (logs, phonebooks) from modern multi-vendor endpoints.
• Tftp-hpa Server Core: Out-of-the-box bootstrap provisioning transport for classic endpoints and network switch flash images.
• Vsftpd Core Engine: Dedicated FTP/SFTP file server core to accommodate legacy endpoints requiring standard FTP boot channels.
• Dnsmasq Engine: Dynamic DHCP allocation server routing universal Option 66 (HTTP/TFTP URLs) and multi-vendor option strings (such as Option 150 for Cisco paths or Option 43 for targeted vendor scopes).
• OpenLLDP Daemon: Intercepts standard vendor-neutral LLDP and LLDP-MED data-link layer topology broadcasts to track switch ports and endpoints instantly.
• Chrony / NTP Core: Universal local clock synchronization anchor ensuring matching timelines for all network endpoints completely cut off from the web.
• Iptables Firewall Matrix: Secure boundary filtering protecting host interfaces and structuring traffic pipelines.
• SQLite Storage Core: Relational index tracking firmware tags, network leases, and phone profile links with power-failure WAL safety flags enabled.
• Python 3 Application Language: Automation layer processing network loops, verifying XML formatting schemas, and translating multi-vendor profiles.
• Archive & Fetch Toolkit (tar, unzip, curl): Underlying utilities enabling the storage layer to retrieve, unpack, and arrange compressed multi-vendor software images cleanly.

🛠️ Core Platform Pillars & Deployed Architecture


1. Dual-Engine Provisioning & Device-Specific Profile Syntax

• Sequential Auto-Assignment Engine (oscm_generator.py): A unified Python automation script that reads local network events, automatically queries a localized SQLite index database (oscm.db), and sequentially auto-assigns extensions and hardware profiles.
• Automated Configuration Validation Checks: Incorporates inline automated XML well-formedness parsing checks within the Python engine to validate device configuration profiles before committing them live to the Nginx provisioning tree, preventing endpoint boot-loop errors.
• Model-Specific XML Formatting Profiles: Standardizes device registration by dynamically compiling custom configuration profiles engineered for specific hardware device families and behavioral lines:
	• Standard Business Flat Profiles: Formatted with standard Title Case flat XML configuration mapping tags (such as proxy enables, registration expirations, and custom dial plan parameters) targeting classic Linksys/Cisco SPA962 desktop endpoints and legacy gateway configurations.
	• Color Screen Small Business Profiles: Formatted using standard lowercase formatting tags combined with explicit hardware line key function string bindings to activate physical device keys smoothly and align registration settings on Cisco SPA525G models.
	• Structured Enterprise Configurations: Compiles native structured configuration formats (such as XML profile blocks) engineered to align with Cisco 7900 series (e.g., 7945, 7965) and Cisco 8800 series (e.g., 8811, 8845, 8861) desktop ecosystems via standard device file names.

2. Multi-Vendor Appliance Expansion Layer

• Analog Gateway Trunk Integration: Provisioning profiles that automatically map dual-stage FXS (internal extension) and FXO (physical PSTN landline) port behaviors. It handles local impedance tracking and maps standard Asterisk peer definitions to bridge analog copper landlines directly into the VoIP core via legacy Linksys SPA3102 voice gateways.
• Enterprise Services Routers Deployment: External XML tracking templates that coordinate integrated voice and data ports on legacy routing appliances, such as the Cisco SRP500 series. It deploys localized security firewalls, routing tables, and SIP trunk parameters directly down the wire to ensure structured local routing path definitions.
• Managed Network Switch Infrastructure Control: Automated generation of flat configuration command-line files designed to deploy secure port bindings, configure voice VLAN priorities, and maintain secure interface settings across enterprise-managed hardware switches.

3. Layer-2 Network Discovery: Proprietary CDP vs. Open-Source LLDP

• Cisco Discovery Protocol (CDP) Legacy Layer: Accommodates legacy vendor environments by listening for CDP frames. CDP acts as the classic data-link layer protocol used natively by Cisco and Linksys hardware to share device identities, capabilities, and native VLAN requirements directly between hardware neighbors.
• Link Layer Discovery Protocol (LLDP / LLDP-MED) Pulse: Maximizes compatibility across open infrastructure by deploying LLDP (powered by the OpenLLDP project daemon core), the standard, vendor-neutral open-source industry alternative to CDP. By standardizing on the media-endpoint extension (LLDP-MED), the discovery daemon establishes broad cross-vendor compatibility.
• Automated Zero-Touch Asset Identification: The moment any managed switch, VoIP phone, or appliance router is plugged into the physical network wire, it broadcasts its asset identity via raw LLDP/CDP frames. OSCM catches these frames live, maps the exact physical switch port topology, identifies the connected vendor model, and extracts hardware properties instantly without requiring manual MAC address tracking.

4. Downstream Roadmap: Advanced Localized Cloud Feature Reclamation

• Unified Collaboration & Media Integration: Slated for downstream injection in the platform's build chain, OSCM will natively absorb a complete suite of communication tools. Built-in chat, localized group paging networks, interactive meeting bridges, and multi-endpoint file sharing will be embedded natively right inside the single unified OSCM web interface using lightweight open-source system alternatives.
• Sovereign Mail & Messaging Engine: Integrates lightweight open-source mail transfer cores into the appliance backend. This will route independent local mailboxes, handle voice-to-text messaging alerts, and pipe voicemail-to-email notifications directly to endpoints, mirroring the capabilities of enterprise systems without requiring outbound external data pipelines.

5. Zero-Touch Provisioning (ZTP) Subnet Delivery

• Dynamic Network Option Routing Engine (dnsmasq.conf): Integrates the automated LLDP/CDP discovery metrics directly with a network configuration server. The engine automatically maps custom DHCP lease option strings (such as Option 66 for standard TFTP/HTTP boot paths used by SPA lines, and Option 150 for specialized unified boot paths used by enterprise lines) to instantly inject targeted configuration files over isolated staging networks.
• Automated Event-Driven Lease Trigger (dhcp-script): Binds local network allocations directly to the compiler framework. By utilizing the native dhcp-script hook inside the dnsmasq core engine, the second an endpoint receives or renews an IP lease, dnsmasq fires an execution trigger that launches oscm_generator.py. This instantly registers the device properties and processes the profile matrix without lag or manual tracking loops.
• Automated Symlink Intercept Layer: The Python compiler automatically generates a multi-format symlink matrix pointing directly back to a master configuration sheet. This ensures that out-of-the-box hardware seamlessly pairs with its profile regardless of factory-default firmware assumptions.

6. Hardened System Automation, Storage, & Compliance Blueprint

• Local SQLite Asset Index Matrix (oscm.db): Maintains lightning-fast interface telemetry, active network lease tracking, and Layer-2 port topology mappings for all discovered infrastructure.
• Dynamic Power-Failure Relational Database Resilience: To survive sudden local power interruptions without data loss, the SQLite data core explicitly forces Write-Ahead Logging (WAL) and synchronous checkpointing flags on oscm.db, protecting active lease history and assignment vectors against block corruption.
• Master System Deployment & Installer Core (oscm_compiler.sh): A centralized infrastructure deployment script designed to unpack application archives, build native system folder hierarchies, establish persistent symbolic links straight to core daemon directories (/etc/asterisk/, /etc/nginx/), and update kernel managers (systemctl daemon-reload).
• Automated Repository Backup Vault (oscm_backup_repo.sh): A custom local synchronization script that recursively backs up active Python files, dumps the database architecture to flat text (oscm.db.sql), mirrors network configurations, and renames local frontend headers to protect the raw server file directory listing. To guarantee safe text-editor parsing and prevent unintended code execution over the web, the backup engine automatically enforces a universal .txt extension append rule onto all configuration files and scripts.
• Compliance, Licensing, and Staging Requirements:Passive Network Interoperability: OSCM operates strictly as a passive listener and standard responder to network topology broadcast frames (IEEE 802.1AB LLDP / Industry Standard CDP) natively emitted by hardware endpoints. The platform does not alter, patch, or reverse-engineer proprietary firmware binaries, nor does it circumvent access controls on physical devices. All configuration layouts are compiled in standard, open formats (XML/Text) based entirely on publicly available RFC protocol specifications.Bring Your Own Firmware (BYOF) Alignment: OSCM does not bundle, host, or distribute proprietary third-party firmware images. The platform is strictly an open-source configuration management engine. End-users are entirely responsible for securing appropriate firmware licensing directly from the original equipment manufacturer (OEM) for their specific hardware assets.End-of-Life (EOL) Sustainability Framework: OSCM is specifically tailored to extend the operational lifespan of End-of-Life (EOL) infrastructure. Because original equipment manufacturers no longer provide active cloud management or updates for these legacy assets, OSCM provides a safe framework for sustainable local hardware recycling, provided that users supply their own licensed firmware binaries where required.Enterprise Sanitation Standards: To ensure network hygiene and baseline compatibility, all hardware assets introduced to the OSCM deployment lifecycle must undergo a full factory-default hard reset prior to staging. This ensures the erasure of previous corporate network data, cryptographic keys, and legacy provisioning paths, establishing a clean operational baseline strictly within the isolated local Voice VLAN.

7. Isolated Web & Core VoIP Audio Pipeline Separated by VLANs

• Isolated Web Server Subsystem (nginx-oscm.conf): A secure web server topology running on an isolated network port. It explicitly hosts distinct location blocks for centralized phone provisioning, dynamic Flask web dashboards, specialized audio engine pipelines (serving mono 8000Hz 8-bit μ-law ringtones), live XML phonebook directories, and camera media stream proxies.
• Isolated Time Synchronization Topology: Includes a localized Network Time Protocol (NTP) daemon bound directly to the firewalled Voice VLAN interface, serving standard time arrays to hardware endpoints that are completely cut off from outbound internet access to preserve log temporal consistency and registration alignments.
• Multi-Interface Network & VLAN Isolation Layer: Bridges a dual-interface network card layout to guarantee total perimeter protection. It strictly separates the primary Management LAN Interface (used for local browser visibility, file updates, and secure router port translation) from a dedicated, firewalled Voice VLAN Subnet Interface that handles raw TFTP phone provisioning and local Asterisk registrations.
• Sovereign Telephony Integration: Built-in hardware interfaces mapping to Asterisk SIP endpoint core definition frameworks (pjsip.conf), physical telephone line PCIe card routing configurations, message waiting indicator (MWI) relays, and internal dial plan matrices.
