#!/bin/bash
set -e

# ANSI color codes
GRNB='\033[1;32m'
CYNB='\033[1;36m'
YLWB='\033[1;33m'
REDB='\033[1;31m'
YLW='\033[0;33m'
NC='\033[0m' # No Color

DIR__=$(dirname $0)
if [[ ! -e $1 || ! -e "$2/main/verilog" ]]; then
  echo 'Usage : validate.sh {TestBenchName} {LogisimCompilationRoot}'
  echo 'e.g. : validate.sh HW1/tb0.v ~/logisim_evolution_workspace/bench/'
  exit
fi
rm -rf $2/main/verilog/toplevel
python "$DIR__/fixgenlabels.py" $2/main/verilog/*/*.v
iverilog -g2009 -o "$1.out" "$1" $2/main/verilog/*/*.v

# Execute the file and process its output line by line
while IFS= read -r line; do
    if [[ "$line" == *"ACCEPTED"* ]]; then
        echo -e "${GRNB}${line}${NC}"
    elif [[ "$line" == *"FAILED"* ]]; then
        echo -e "${REDB}${line}${NC}"
    elif [[ "$line" =~ ^[[:space:]]*[0-9]+[[:space:]]*/[[:space:]]*[0-9]+[[:space:]]*$ ]]; then
        a=$(echo "$line" | awk '{print $1}')
        b=$(echo "$line" | awk '{print $3}')
        if [[ "$a" -eq "$b" ]]; then
            echo -e "${GRNB}${line}${NC}"
        elif [[ "$a" -eq 0 ]]; then
            echo -e "${REDB}${line}${NC}"
        else
            echo -e "${YLWB}${line}${NC}"
        fi
    else
        echo -e "${YLW}${line}${NC}"
    fi
done < <("./$1.out")
