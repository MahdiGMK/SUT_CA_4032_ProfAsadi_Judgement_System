import os
import xml.etree.ElementTree as ET
from lxml import etree

def ensure_directory_exists(file_path):
    os.makedirs(os.path.dirname(file_path), exist_ok=True)

def create_new_config(file_path, key, value):
    ensure_directory_exists(file_path)
    root = etree.Element("map", MAP_XML_VERSION="1.0")
    etree.SubElement(root, "entry", key=key, value=value)
    write_config(file_path, root)
    print(f"Created new config file and added '{key}' with value '{value}'")

def write_config(file_path, root):
    with open(file_path, "wb") as f:
        f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
        f.write(b'<!DOCTYPE map SYSTEM "http://java.sun.com/dtd/preferences.dtd">\n')
        f.write(etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=False))

def update_logisim_config(file_path, key, value):
    if not os.path.exists(file_path):
        create_new_config(file_path, key, value)
        return
    
    parser = etree.XMLParser(remove_blank_text=True)
    tree = etree.parse(file_path, parser)
    root = tree.getroot()
    
    entry = root.find(f"entry[@key='{key}']")
    if entry is not None:
        if entry.get("value") != value:
            entry.set("value", value)
            write_config(file_path, root)
            print(f"Updated '{key}' to '{value}' in {file_path}")
        else:
            print(f"'{key}' already set to '{value}'")
    else:
        etree.SubElement(root, "entry", key=key, value=value)
        write_config(file_path, root)
        print(f"Added '{key}' with value '{value}' to {file_path}")

# Example usage
config_path = os.path.expanduser("~/.java/.userPrefs/com/cburch/logisim/prefs.xml")
update_logisim_config(config_path, "afterAdd", "Verilog")
