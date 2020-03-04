# ParFlow Singularity Container Demonstration

The ParFlow container is built as a SCIF-app container, providing access to both sequential and parallel 
builds of ParFlow. See additional information about [Apps in Singularity](https://sylabs.io/guides/3.3/user-guide/definition_files.html?highlight=apps#apps)

## Prerequisits
- Host OS must have Singularity installed (See [Installing Singularity](https://sylabs.io/guides/3.3/user-guide/installation.html))

## Quickstart
Steps:
1. Clone this repository
`git clone https://github.com/arezaii/pf_singularity_demo`
2. cd to the repository directory
`cd pf_singularity_demo`
3. run the shell script
`./run_test.sh LW 1 1 1 1`

## Running Performance Test Cases
The shell script run_test.sh facilitates running tests on different domains.

Usage: 
```bash
$ ./run_test.sh <domain> <P> <Q> <R> <TimeSteps>
```

## Test Domains

There are several test domains for performance analysis contained in the perf_tests folder.

* LW - Little Washita 
* clayl - ClayL
* conus_ru - CONUS Clip - Run off
* conus_tfg - CONUS Clip - Terrain Following Grid

### Little Washita
Natural model of the Little Washita watershed in Kansas.

***Domain Details***
* Number of Cells: 41x41x50 (X,Y,Z)
* Horizontal Resolution: 1km
* Vertical Resolution: 2m

***Technical Details***
* CLM enabled with NLDAS Forcings
* Timestep: 1hr
* Suburface: Heterogeneous

### ClayL
Synthetic model with flat surface and many thin, vertical layers

***Domain Details***

### CONUS Run-off
Natural topography with an impervious surface

### CONUS Terrain Following Grid
Natural topography with the terrain following grid (TFG) feature enabled

## About Apps

to run:
```bash
$ singularity run --app <app_name> </path/to/singularity_container.sif> <.tcl input file>
```
- par = distributed build of ParFlow, -DPARFLOW_AMPS_SEQUENTIAL_IO=False
- seq = sequential build of ParFlow, -DPARFLOW_AMPS_SEQUENTIAL_IO=True

See additional information about [Apps in Singularity](https://sylabs.io/guides/3.3/user-guide/definition_files.html?highlight=apps#apps)


## To Build Container
To build container from recipe file, user must have root access on the machine. Alternatively, one can use a remote build service such as [cloud.sylabs.io](https://cloud.sylabs.io/builder)
General build command is of the form:
```bash
$ sudo singularity build <destination/path/to/singularity_container.sif> <Singularity definition file>
```

as a specific example:
```bash
$ sudo singularity build ~/pf_singularity_ompi Singularity.parflow_ompi
```

## To Use ParFlow in Container
example of running the LW test case in `parflow/test/washita/tcl_scripts` directory
```bash
$ singularity run --app par ~/pf_singularity_ompi LW_Test.tcl
```

## Pull from Sylabs Cloud

```bash
$ singularity pull [destination image name] library://arezaii/default/parflow_demo:master
```
then to use it:
```bash
singularity run --app par <singularity image file> LW_Test.tcl
```


## Testing

Because singularity containers are immutable and ParFlow tests write to disk, you must expand the image to a writable sandbox.
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

There will now be a new directory pf_singularity_parflow_ompi_test/ that is the root of the container.
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
