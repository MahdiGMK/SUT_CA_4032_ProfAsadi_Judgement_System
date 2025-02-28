#!/bin/bash
set -e
python ./fixboardmap.py $1
./logisim -f $1.tmp main ALCHITRY_AU_IO || echo 
