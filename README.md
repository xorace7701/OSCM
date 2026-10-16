# OSCM
🛰️ Project Summary: OSCM (Open Systems Communications Manager) v1.0

OSCM is an ultra-lean appliance platform designed for the complete local sovereignty, network automation, and automated lifecycle provisioning of legacy enterprise communications infrastructure (including Cisco VoIP endpoints, Linksys gateways, and routing silicon). By completely stripping away obsolete vendor cloud dependencies, licensing paywalls, and proprietary presentation layers, OSCM maximizes the operational lifespan of robust communication hardware—delivering a permanent open standard that ensures 20+ years of infrastructure autonomy.

📦 Core OS Project Core Dependencies

To maintain a lean footprint without reinventing proven architectures, OSCM sits directly on top of, orchestrates, and links into the following native open-source project cores as its foundational daemon dependency layers:
• Linux Server Core: Serves as the bare-metal or virtualized host operating system framework, providing the underlying kernel manager and system initialization daemon (systemd).
• Asterisk (VoIP Engine Core): Handles the foundational Session Initiation Protocol (SIP) structures, private branch exchange (PBX) channel routing pipelines, endpoint signaling authentication, media streams, and voice mailboxes via the standard pjsip channel driver.
• Nginx (Web Engine Subsystem): Acts as the high-speed reverse proxy and front-facing web host, distributing secure HTTP/HTTPS provisioning configuration payloads, serving static ringtone media, and proxying dashboard traffic.
• Dnsmasq (Network & Provisioning Transport Core): Executes localized DHCP IP address lease allocations, routes custom network option strings, and powers high-speed Trivial File Transfer Protocol (TFTP) provisioning data streams.
• OpenLLDP (Discovery Daemon): Listens natively for Layer-2 hardware Link Layer Discovery Protocol broadcast frames, translating network switch port topology data directly into the application matrix.
• SQLite (Data Storage Core): Provides a zero-configuration, transactional relational database engine used to index active asset configurations, extensions, and network lease telemetry without separate server overhead.
• Python 3 (Automation Engine Language): The native backend software environment used to run the asset synchronization script routines, parse database entries, and dynamically compile device profile layouts.

🛠️ Core Platform Pillars & Deployed Architecture


1. Dual-Engine Provisioning & Device-Specific Profile Syntax

• Sequential Auto-Assignment Engine (oscm_generator.py): A unified Python automation script that intercepts local network broadcast events, automatically queries a localized SQLite index database (oscm.db), and sequentially auto-assigns extensions and hardware profiles.
• Model-Specific XML Formatting Profiles: Bypasses legacy registration loops by dynamically compiling tailor-made configuration profiles engineered for specific hardware device behaviors:
	• Standard VoIP Matrix Profiles: Formatted with standard Title Case flat XML configuration mapping tags (such as proxy enables, registration expirations, and custom dial plan parameters).
	• Color Screen Matrix Profiles: Enforces strict lowercase user-agent formatting tags combined with explicit hardware line key function string bindings to forcefully activate physical device keys and clear registration errors.

2. Multi-Vendor Cisco & Linksys Appliance Expansion Layer

• Analog Gateway Trunk Integration: Hardened provisioning profiles that automatically map dual-stage FXS (internal extension) and FXO (physical PSTN landline) port behaviors. It handles strict local impedance tracking and maps raw Asterisk peer definitions to bridge analog copper landlines directly into the VoIP core via physical hardware gateways (such as the Linksys SPA3102).
• Enterprise Services Routers Deployment: External XML tracking templates that take complete command of integrated voice and data ports on legacy routing appliances (such as the Cisco SRP500 series). It pushes localized security firewalls, routing tables, and SIP trunk parameters directly down the wire to lock the routing core out of vendor cloud call-homes.
• Managed Network Switch Infrastructure Control: Automated generation of flat configuration command-line files designed to push secure port bindings, configure voice VLAN priorities, and lock down secure interface settings across enterprise-managed hardware switches.

3. Layer-2 Network Discovery: Proprietary CDP vs. Open-Source LLDP

• Cisco Discovery Protocol (CDP) Legacy Layer: Accommodates legacy vendor environments by listening for CDP frames. CDP acts as the classic, proprietary data-link layer protocol used natively to share device identities, capabilities, and native VLAN requirements directly between hardware neighbors.
• Link Layer Discovery Protocol (LLDP / LLDP-MED) Ignition Pulse: Maximizes compatibility across open infrastructure by deploying LLDP (powered by the OpenLLDP project daemon core), the standard, vendor-neutral open-source replacement for CDP. By standardizing on the media-endpoint extension (LLDP-MED), the discovery daemon neutralizes vendor lock-in.
• Automated Zero-Touch Asset Identification: The moment any managed switch, VoIP phone, or appliance router is plugged into the physical network wire, it broadcasts its asset identity via raw LLDP/CDP frames. OSCM catches these frames live, maps the exact physical switch port topology, identifies the connected vendor model, and extracts hardware properties instantly without requiring manual MAC address tracking.

4. Downstream Roadmap: Advanced Localized Cloud Feature Reclamation

• Unified Collaboration & Media Integration: Slated for downstream injection in the platform's build chain, OSCM will natively absorb the complete suite of communication tools formerly monopolized by corporate subscription clouds. Built-in chat, localized group paging networks, interactive meeting bridges, and multi-endpoint file sharing will be embedded natively right inside the single unified OSCM web interface using lightweight open-source system alternatives.
• Sovereign Mail & Messaging Engine: Integrates lightweight open-source mail transfer cores into the appliance backend. This will route independent local corporate mailboxes, intercept voice-to-text messaging alerts, and pipe voicemail-to-email notifications directly to endpoints, mirroring the capabilities of End-of-Life (EOL) enterprise systems without requiring outbound data pipelines.

5. Zero-Touch Provisioning (ZTP) Subnet Delivery

• Dynamic Network Option Routing Engine (dnsmasq.conf): Integrates the automated LLDP/CDP discovery metrics directly with a high-speed network configuration server. The engine automatically maps custom DHCP lease option strings (such as Option 66 for standard TFTP boot paths and Option 150 for advanced Cisco Unified XML paths) to instantly inject targeted configuration files over isolated staging networks.
• Automated Symlink Intercept Layer: The Python compiler automatically generates a multi-format symlink matrix pointing directly back to a master configuration sheet. This ensures that out-of-the-box hardware instantly locks onto its profile regardless of factory-default firmware assumptions.

6. Hardened System Automation & Storage Blueprint

• Local SQLite Asset Index Matrix (oscm.db): Maintains lightning-fast interface telemetry, active network lease tracking, and Layer-2 port topology mappings for all discovered infrastructure.
• Master System Deployment & Installer Core (oscm_compiler.sh): A centralized infrastructure deployment script designed to explode application archives, build native system folder hierarchies, establish persistent symbolic links straight to core daemon directories (/etc/asterisk/, /etc/nginx/), and force-reload kernel managers (systemctl daemon-reload).
• Automated Repository Backup Vault (oscm_backup_repo.sh): A custom local synchronization script that recursively backs up active Python files, dumps the database architecture to flat text (oscm.db.sql), mirrors network configurations, and renames local frontend headers to protect the raw server file directory listing. To guarantee safe text-editor parsing and prevent unintended code execution over the web, the backup engine automatically enforces a universal .txt extension append rule onto all configuration files and scripts.

7. Isolated Web & Core VoIP Audio Pipeline Separated by VLANs

• Isolated Web Server Subsystem (nginx-oscm.conf): A secure web server topology running on an isolated network port. It explicitly hosts distinct location blocks for centralized phone provisioning, dynamic Flask web dashboards, specialized audio engine pipelines (serving mono 8000Hz 8-bit μ-law ringtones), live XML phonebook directories, and surveillance camera MJPEG video stream proxies.
• Multi-Interface Network & VLAN Isolation Layer: Bridges a dual-interface network card layout to guarantee total perimeter protection. It strictly separates the primary Management LAN Interface (used for local browser visibility, file updates, and secure router port translation) from a dedicated, firewalled Voice VLAN Subnet Interface that handles raw TFTP phone provisioning and local Asterisk registrations.
• Sovereign Telephony Integration: Built-in hardware interfaces mapping to Asterisk SIP endpoint core definition frameworks (pjsip.conf), physical telephone line PCIe card routing configurations, message waiting indicator (MWI) relays, and internal dial plan matrices.
