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

SINGULARITY_FILE=parflow_demo_omp_expiremental.sif
if [[ ! -f "$SINGULARITY_FILE" ]]; then
    singularity pull $SINGULARITY_FILE library://arezaii/default/parflow_demo:sha256.4abaf31a5dcae6a7bc9e8d45d72abd51dcc4489e5079a9f000917d632d7de563    
fi



cd ./perf_tests
echo "running tests for $name...may take a while..."
SINGULARITYENV_OMP_NUM_THREADS=1 singularity run --app omp  ../$SINGULARITY_FILE exec_test_suite.tcl $name $P $Q $R $timesteps
echo "tests complete. Results are in perf_tests/$name/results.csv"

