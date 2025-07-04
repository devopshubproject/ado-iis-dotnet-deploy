#!/usr/bin/env python3
import json

with open("tf_output.json") as f:
    tf_data = json.load(f)

host = tf_data["iis_server_ip"]["value"]

inventory = {
    "iis_servers": {
        "hosts": [host],
        "vars": {
            "ansible_user": "Administrator",
            "ansible_password": "YourStrongPassword",
            "ansible_connection": "winrm",
            "ansible_winrm_transport": "ntlm",
            "ansible_winrm_server_cert_validation": "ignore"
        }
    }
}

print(json.dumps(inventory))
