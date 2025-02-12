#!/bin/sh
if [[ ! -e $1 || ! -e "$2/main/verilog" ]]; then
  echo 'Usage : ./validate.sh {TestBenchName} {LogisimCompilationRoot}'
  echo 'e.g. : ./validate.sh tb.v ~/logisim_evolution_workspace/bench/'
  exit
fi

iverilog $1 $2/main/verilog/{circuit,gates}/*.v -g2009 -o $1.out
./$1.out
