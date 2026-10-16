import os
import sqlite3
import json

# Setup relative tracking paths inside your staging folder
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(BASE_DIR, 'oscm_data.db')
SCHEMA_PATH = os.path.join(BASE_DIR, 'apps', 'schema.sql')
CONFIG_DIR = os.path.join(BASE_DIR, 'config')

def init_database():
    """Reads schema.sql to initialize the high-speed index database."""
    print("[OSCM ENGINE] Initializing SQLite Data Engine...")
    
    if not os.path.exists(SCHEMA_PATH):
        print(f"[ERROR] Schema file missing at: {SCHEMA_PATH}")
        return False
        
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    with open(SCHEMA_PATH, 'r') as f:
        schema_sql = f.read()
        
    cursor.executescript(schema_sql)
    conn.commit()
    conn.close()
    print(f"[OSCM ENGINE] Database online and verified at: {DB_PATH}")
    return True

def sync_asset_to_json(mac_address):
    """
    Fetches an asset record from SQLite and immediately writes a 
    flat-file JSON backup indexed by MAC address for total text-editor control.
    """
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row  # Enables column fetching by text name
    cursor = conn.cursor()
    
    # Extract asset details
    cursor.execute("SELECT * FROM assets WHERE mac_address = ?", (mac_address,))
    asset = cursor.fetchone()
    
    if not asset:
        conn.close()
        return False
        
    asset_data = dict(asset)
    
    # Extract structural peripheral settings for this MAC
    cursor.execute("SELECT * FROM hardware_keys WHERE mac_address = ?", (mac_address,))
    keys = [dict(row) for row in cursor.fetchall()]
    asset_data['hardware_keys'] = keys
    
    cursor.execute("SELECT * FROM peripheral_media WHERE mac_address = ?", (mac_address,))
    media = cursor.fetchone()
    asset_data['media_profiles'] = dict(media) if media else {}
    
    conn.close()
    
    # Ensure the config folder target exists
    os.makedirs(CONFIG_DIR, exist_ok=True)
    
    # Save the mirror JSON file
    json_filename = f"profile_{mac_address.lower()}.json"
    json_out_path = os.path.join(CONFIG_DIR, json_filename)
    
    with open(json_out_path, 'w') as json_file:
        json.dump(asset_data, json_file, indent=4)
        
    print(f"[OSCM ENGINE] Sovereign JSON Profile synced: {json_out_path}")
    return True

if __name__ == "__main__":
    # Test initialization when run independently
    init_database()
