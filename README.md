# ParFlow Singularity Container Demonstration

The Singularity container is built with ParFlow installed as a SCIF-app, providing access to both sequential and parallel 
builds of ParFlow. See additional information about [Apps in Singularity](https://sylabs.io/guides/3.3/user-guide/definition_files.html?highlight=apps#apps)

## Prerequisites
- Host OS must have Singularity installed (See [Installing Singularity](https://sylabs.io/guides/3.3/user-guide/installation.html))

## Quickstart
Steps:
1. Clone this repository
```
git clone https://github.com/arezaii/pf_singularity_demo
```
2. cd to the repository directory
```
cd pf_singularity_demo
```
3. run the shell script to execute tests for Little Washita domain on 1 processor, for 1 timestep
```
./run_test.sh LW 1 1 1 1
```

## Running Performance Test Cases
The shell script run_test.sh facilitates running tests on different domains.

Usage: 
```bash
$ ./run_test.sh <domain> <P> <Q> <R> <TimeSteps>
```

where
* domain is a test domain defined below
* P, Q, R are integers defining processor topology in X, Y, Z directions
* Timesteps is number of timesteps to execute 

## Test Domains

There are several test domains for performance analysis contained in the perf_tests folder.

* LW - Little Washita 
* clayl - ClayL
* conus_ru - CONUS Clip - Run off
* conus_tfg - CONUS Clip - Terrain Following Grid

### Little Washita
Natural model of the Little Washita watershed in Oklahoma.

***Domain Details***
* Number of Cells: 84,050, 41x41x50 (X,Y,Z) 
* Horizontal Resolution: 1km
* Vertical Resolution: 2m

***Technical Details***
* CLM enabled with NLDAS Forcings
* Timestep: 1hr
* Suburface: Heterogeneous
* Initial Condition: Pressure file from spin-up

### ClayL
Synthetic model with completely flat surface and many thin, vertical layers

***Domain Details***
* Number of Cells: 2.4M for 1 core. Scales with processor count, 100Px100Qx240 (X,Y,Z)
* Horizontal Resolution: 1m
* Vertical Resolution: 0.025m

***Technical Details***
* No CLM, constant simulated rain on top surface @ .0008 mm/hr
* Timestep 1hr
* Subsurface: Homogeneous
* Initial Condition: Dry

### CONUS Run-off
Natural topography with an impervious surface (parking lot simulation)

***Domain Details***
* Number of Cells: 1,562,500 1250x1250x1 (X,Y,Z)
* Horizontal Resolution: 1km
* Vertical Resolution: 0.10m

***Technical Details***
* No CLM, period of 1 hour simulated rain on top surface @ .005 mm/hr, then recession for 1000 hours
* Timestep: 6 minutes
* Subsurface: Homogeneous
* Initial Condition: Dry


### CONUS Terrain Following Grid
Natural topography with the terrain following grid (TFG) feature enabled

***Domain Details***
* Number of Cells: 1,125,000 750x750x2 (X,Y,Z)
* Horizontal Resolution: 1km
* Vertical Resolution: toplayer=1m, bottomlayer=100m

***Technical Details***
* No CLM, seepage face boundary condition type on top layer, @ 0.00001 
* Timestep: 100000
* Subsurface: Homogeneous
* Initial Condition: Dry


## About Apps
The demo container has two apps installed:
- par = distributed build of ParFlow, -DPARFLOW_AMPS_SEQUENTIAL_IO=False
- seq = sequential build of ParFlow, -DPARFLOW_AMPS_SEQUENTIAL_IO=True

to run:
```bash
$ singularity run --app <app_name> </path/to/singularity_container.sif> <.tcl input file>
```

See additional information about [Apps in Singularity](https://sylabs.io/guides/3.3/user-guide/definition_files.html?highlight=apps#apps)


## To Build Container
The quickest way to build is to use a remote build service such as [cloud.sylabs.io](https://cloud.sylabs.io/builder)
If a user has root access, they can build from the definition file, conventionally named Singularity.

General build command is of the form:
```bash
$ sudo singularity build <destination/path/to/singularity_container.sif> <Singularity definition file>
```

as a specific example:
```bash
$ sudo singularity build ~/pf_singularity_demo.sif Singularity
```

## To Use ParFlow in Container

Example of running the LW test case in `parflow/test/washita/tcl_scripts` directory

```bash
$ singularity run --app par ~/pf_singularity_demo.sif LW_Test.tcl
```

## Pull from Sylabs Cloud
To pull the pre-built image from Sylabs Cloud:
```bash
$ singularity pull [destination image name] library://arezaii/default/parflow_demo:master
```


## Testing

Because singularity containers are write protected and ParFlow tests write to disk, you must expand the image to a writable sandbox.
This requires super user access, similar to building a container from the definition file.

### Make Container Writable

First, create a writable sandbox from the immutable container using Singularity's build command:
```bash
sudo singularity build --sandbox <directory_to_create_for_sandbox/> <singularity_container>
```

as an example, if you had pulled the parflow_ompi image from shub:
```bash
sudo singularity build --sandbox parflow_demo_master_sandbox/ parflow_demo_master.sif
```

There will now be a new directory parflow_demo_master_sandbox/ that is the root of the container.
Editing any of the folder contents will require super user permissions.


You can enter a console into the container now by using the Singularity shell command:
```bash
sudo singularity shell --writable <directory_to_create_for_sandbox/>
```

### Run Tests

After making the container writable and accessing it through a shell, both documented above, running the ParFlow
tests can be done by changing directories and exporting the PARFLOW_DIR environment variable for either distributed 
or sequential builds of ParFlow.

Take note of the ParFlow build and install directories in the container:

**Sequential Build**
* build directory: /home/parflow/build_seq
* install directory: /home/parflow/pfdir_seq

**Distributed Build**
* build directory: /home/parflow/build_par
* install directory: /home/parflow/pfdir_par

```bash
> cd /home/parflow/<build_dir>
> export PARFLOW_DIR=/home/parflow/<install_dir> 
> make test
```
