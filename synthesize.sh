#!/bin/sh
set -e
python ./fixboardmap.py $1
java -jar ./logisim.jar -f $1.tmp main ALCHITRY_AU_IO || echo 
