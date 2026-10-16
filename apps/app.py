#!/usr/bin/env python3
# ====================================================================
#               OSCM — Sovereign Dashboard Backend API 
#                       Version 1.2 - Hardened
# ====================================================================
import os
import sqlite3
import subprocess
from flask import Flask, render_template, request, jsonify

app = Flask(__name__, 
            template_folder=os.path.join(os.path.dirname(os.path.dirname(__file__)), 'ui', 'templates'),
            static_folder=os.path.join(os.path.dirname(os.path.dirname(__file__)), 'ui'))

# Unified database track matching your native storage engine layout
DB_PATH = "/var/www/oscm/apps/oscm.db"
GENERATOR_SCRIPT = "/var/www/oscm/oscm_generator.py"

def get_db_connection():
    """Establishes a safe connection to your centralized compiler database."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/dashboard')
@app.route('/dashboard/')
def dashboard_home():
    """Serves the green terminal console layout template."""
    return render_template('index.html')

@app.route('/dashboard/api/devices')
@app.route('/dashboard/api/devices/')
def list_devices():
    """Fetches registered devices from your verified assets SQLite core index."""
    try:
        conn = get_db_connection()
        # Mapped directly to your actual assets column naming structure
        devices = conn.execute("""
            SELECT 
                mac_address AS mac, 
                assigned_extension AS extension, 
                hardware_model AS model, 
                engine_mode AS mode 
            FROM assets
        """).fetchall()
        
        # Inject standard fallback attributes to fulfill your index.html grid criteria safely
        output = []
        for dev in devices:
            d = dict(dev)
            d['display_name'] = f"Ext {d['extension']}"
            output.append(d)
            
        conn.close()
        return jsonify(output), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/dashboard/api/provision', methods=['POST'])
@app.route('/dashboard/api/provision/', methods=['POST'])
def provision_device():
    """Receives UI form input, updates the database, and forces a TFTP profile sync."""
    data = request.get_json() or request.form
    
    mac = data.get('mac', '').strip().lower()
    extension = data.get('extension', '').strip()
    model = data.get('model', '').strip()
    mode = data.get('mode', '').strip()
    
    if not mac or not extension or not model or not mode:
        return jsonify({"status": "error", "message": "Missing required fields"}), 400

    try:
        # 1. Update your verified assets SQLite index layout tables
        conn = get_db_connection()
        conn.execute("""
            INSERT OR REPLACE INTO assets (
                mac_address, 
                hardware_model, 
                vlan_id, 
                engine_mode, 
                assigned_extension, 
                developer_mode_unlocked
            ) VALUES (?, ?, ?, ?, ?, ?)
        """, (mac, model, 2, int(mode), extension, 1))
        conn.commit()
        conn.close()
        
        # 2. Fire the global background profile synchronization flag
        result = subprocess.run(['python3', GENERATOR_SCRIPT, '--sync'], 
                                capture_output=True, text=True, check=True)
        
        return jsonify({
            "status": "success", 
            "message": f"Asset {mac} committed securely. Profiles compiled successfully.",
            "output": result.stdout.strip()
        }), 200
        
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    # Runs locally on loopback port 5000 inside the unprivileged sandbox
    app.run(host='127.0.0.1', port=5000, debug=False)
