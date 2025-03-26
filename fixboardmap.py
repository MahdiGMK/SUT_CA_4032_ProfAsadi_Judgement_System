from base64 import encode
import xml.etree.ElementTree as ET
import sys


av = sys.argv
circ = av[1]

tree = ET.parse(circ)


root = tree.getroot()

main_id_node = root.find("./main")
for main in root.findall(f"./circuit[@name='{main_id_node.get('name')}']"):
    main.set('name' , 'main')
    main_id_node.set('name' , 'main')
    main.find("./a[@name='circuit']").set('val' , 'main')
    inpins : list[str] = []
    outpins : list[str] = []
    for pin in main.findall("./comp[@name='Pin']"):
        pinname = pin.find("./a[@name='label']")
        pinout = pin.find("./a[@name='output']")
        assert isinstance(pinname , ET.Element)
        pinname = pinname.get('val')
        assert isinstance(pinname , str)
        if isinstance(pinout, ET.Element):
            pinout = pinout.get('val') == 'true';
        else: pinout = False;
        
        if pinout:
            outpins.append(pinname)
        else:
            inpins.append(pinname)
    
    print("inpins : " , inpins)
    print("outpins : " , outpins)

    
    boardmap = main.find('./boardmap')
    if(boardmap is not None):
        assert isinstance(boardmap , ET.Element)
        boardmap.clear()
        boardmap.set('boardname' , 'ALCHITRY_AU_IO');
    else:
        boardmap = ET.fromstring('<boardmap boardname="ALCHITRY_AU_IO"/>')
        _= main.append(boardmap)
    for pin in inpins:
        boardmap.append(ET.fromstring(f'<mc key="/{pin}" vconst="0"/>'))
    for pin in outpins:
        boardmap.append(ET.fromstring(f'<mc key="/{pin}" open="open"/>'))

tree.write(f'{circ}.tmp' , encoding='utf-8', xml_declaration=True)
