#!/usr/bin/env python3
import json
import subprocess
import sys

class WiFiManager:
    def get_wifi_networks(self, rescan=True):
        """Lấy danh sách WiFi networks và lọc trùng"""
        try:
            cmd = ['nmcli', '-t', '-f', 'SSID,SIGNAL,SECURITY', 'dev', 'wifi', 'list']
            
            if rescan:
                cmd.extend(['--rescan', 'yes'])
            
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            
            if result.returncode != 0:
                return {"error": f"nmcli failed: {result.stderr}"}
            
            wifi_networks = []
            seen_ssids = set()
            
            for line in result.stdout.strip().split('\n'):
                if not line:
                    continue
                    
                parts = line.split(':')
                if len(parts) >= 3:
                    ssid = parts[0].replace('\\:', ':') if parts[0] else "[Hidden]"
                    signal = int(parts[1])
                    security = parts[2]
                    
                    if ssid not in seen_ssids:
                        seen_ssids.add(ssid)
                        saved_password = self.get_saved_password(ssid)
                        
                        wifi_networks.append({
                            "ssid": ssid,
                            "signal_strength": signal,
                            "security": security,
                            "saved_password": saved_password
                        })
            
            # Sắp xếp theo signal mạnh nhất
            wifi_networks.sort(key=lambda x: x["signal_strength"], reverse=True)
            
            return {
                "success": True,
                "count": len(wifi_networks),
                "networks": wifi_networks
            }
            
        except subprocess.TimeoutExpired:
            return {"error": "Scan timeout"}
        except Exception as e:
            return {"error": f"Unexpected error: {str(e)}"}
    
    def get_saved_password(self, ssid):
        """Lấy mật khẩu đã lưu cho WiFi network"""
        try:
            cmd = ['nmcli', '-s', '-g', '802-11-wireless-security.psk', 'connection', 'show', ssid]
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
            
            if result.returncode == 0 and result.stdout.strip():
                return result.stdout.strip()
            return None
        except:
            return None
    
    def display_wifi_with_passwords(self):
        """Hiển thị WiFi networks với mật khẩu đã lưu"""
        result = self.get_wifi_networks()
        
        if not result.get("success"):
            print(f"Error: {result.get('error')}")
            return
        
        print("=== Nearby WiFi ===")
        print()
        
        for network in result["networks"]:
            print(f"SSID: {network['ssid']}")
            password = network["saved_password"]
            print(f"Saved Password: {password if password else '<none>'}")
            print("------------------------")

def main():
    wifi_manager = WiFiManager()
    
    if len(sys.argv) > 1 and sys.argv[1] == "--display":
        wifi_manager.display_wifi_with_passwords()
    else:
        result = wifi_manager.get_wifi_networks()
        print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
