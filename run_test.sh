#!/usr/bin/env bash

if [[ $# < 5 ]]
then
  echo "Usage: $0 <name> <P> <Q> <R> <TimeSteps>"
  echo " where <name> is one of:"
  echo "  * LW - Little Washita"
  echo "  * clayl - ClayL"
  echo "  * conus_ru - CONUS Clip - Run off"
  echo "  * conus_tfg - CONUS Clip - Terrain Following Grid"
  echo "  <P> <Q> <R> are integers defining processor topology in X,Y,Z directions"
  echo "  <TimeSteps> is an integer number of timesteps to run simulation for"
  exit
fi


P=$2
Q=$3
R=$4

name=$1

timesteps=$5

SINGULARITY_FILE=parflow_demo_master.sif
if [[ ! -f "$SINGULARITY_FILE" ]]; then
    singularity pull $SINGULARITY_FILE library://arezaii/default/parflow_demo:sha256.985b1c0621c657592ec8a5bfaadde86e78dcd2eb3d697070787e03841bbc6613
fi



cd ./perf_tests
echo "running tests for $name...this may take a while...output is being redirected to log files"
singularity run --app par ../$SINGULARITY_FILE exec_test_suite.tcl $name $P $Q $R $timesteps
echo "tests complete. Results are in perf_tests/$name/results.csv"
