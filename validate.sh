#!/bin/bash
set -e
DIR__=$(dirname $0)
if [[ ! -e $1 || ! -e "$2/main/verilog" ]]; then
  echo 'Usage : validate.sh {TestBenchName} {LogisimCompilationRoot}'
  echo 'e.g. : validate.sh HW1/tb0.v ~/logisim_evolution_workspace/bench/'
  exit
fi
rm -rf $2/main/verilog/toplevel
python "$DIR__/fixgenlabels.py" $2/main/verilog/*/*.v
iverilog -g2009 -o "$1.out" "$1" $2/main/verilog/*/*.v
echo -e '\033[1;36m'    # Added for printing verilog test output in CYAN BOLD
"./$1.out"
echo -e '\033[0m'       # Reset ANSI
