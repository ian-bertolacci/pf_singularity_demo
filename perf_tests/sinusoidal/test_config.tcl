# configuration file for Parflow test domain


# Load the global configuration
#source ../global_config.tcl

# set the number of runs that will be averaged
set number_of_runs 1

# set the directory where the parflow script will run from
set test_run_dir ./

# set the runname for this test domain
set runname sinusoidal

# define the Parflow run script file
set scriptname sinusoidal.tcl

# mirror the test's output directory for Parflow outputs
# output dir relative to test_run_dir
# TODO: This should not be mirrored, only set once!
set output_dir ./outputs
