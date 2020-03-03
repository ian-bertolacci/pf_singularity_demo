#!/usr/bin/env bash

if [[ $# < 5 ]]
then
  echo "Usage: $0 <name> <P> <Q> <R> <TimeSteps>"
  exit
fi

# if [[ $# == 5 ]]
# then
#   path_to_root=$5
# else
#   path_to_root=$(pwd)
# fi

P=$2
Q=$3
R=$4

name=$1

timesteps=$5

SINGULARITY_FILE=parflow_demo_master.sif
if [[ ! -f "$SINGULARITY_FILE" ]]; then
    singularity pull library://arezaii/default/parflow_demo:sha256.985b1c0621c657592ec8a5bfaadde86e78dcd2eb3d697070787e038
fi



cd ./perf_tests

singularity run --app master ../parflow_demo_omp_expiremental.sif exec_test_suite.tcl $name $P $Q $R $timesteps
