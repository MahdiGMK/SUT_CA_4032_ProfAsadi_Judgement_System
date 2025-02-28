#!/bin/bash
set -e
if [[ ! -e $1 || ! -e "$2/main/verilog" ]]; then
  echo 'Usage : ./validate.sh {TestBenchName} {LogisimCompilationRoot}'
  echo 'e.g. : ./validate.sh ./HW1/tb0.v ~/logisim_evolution_workspace/bench/'
  exit
fi

iverilog -g2009 -o $1.out $1 $2/main/verilog/*/*.v
./$1.out
