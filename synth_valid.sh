#!/bin/bash
set -e
if [[ ! -e $1 || ! -e $2 ]]; then
  echo 'Usage : synth_valid.sh {Circuit} {TestBench}'
  echo 'e.g. : synth_valid.sh HW1/bench.circ HW1/tb0.v'
  echo
  echo 'Synthesis process uses ~/logisim_evolution_workspace/ as main workspace directory'
  echo 'You can change this behaviour by assigning LOGISIM_WORKSPACE environment variable'
  exit
fi
DIR__=$(dirname $0)
LOGISIM_WORKSPACE="${LOGISIM_WORKSPACE:-$HOME/logisim_evolution_workspace}"
echo 'logisim workspace : ' $LOGISIM_WORKSPACE
"$DIR__/synthesize.sh" "$1"
CIRC_NAME=$(basename $1)
SYNTH_DIR=$LOGISIM_WORKSPACE/"$CIRC_NAME".tmp
echo $2 $SYNTH_DIR
"$DIR__/validate.sh" "$2" "$SYNTH_DIR"
