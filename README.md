# coeus-ngsolve
Instructions / scripts for setting up serial and parallel installations of Netgen/Ngsolve on the PSU Coeus or Gaia cluster

## Overview
Following this installation procedure, you should end up with
directories in your home directory something like this:

```
.
├── coeus-ngsolve
├── common
│   ├── install
│   │   ├── bin
│   │   ├── include
│   │   ├── lib
│   │   └── share
│   └── src
│       ├── cmake-3.15.7
│       └── Python-3.6.12
├── NGparallel
│   ├── bin
│   ├── include
│   ├── lib
│   ├── ngsolve
│   └── share
├── NGserial
│   ├── bin
│   ├── include
│   ├── lib
│   ├── ngsolve
│   └── share
└── local
    ├── pyeigfeast
    ├── fiberamp
    └── my_python_project

```

### Step 1

Edit the file `$HOME/.ssh/authorized_keys`, adding the SSH key for your local machine.
This will allow you to use ssh and sftp without having to enter a password each time.

### Step 2

Edit the file `~/.bashrc` using nano, vim or emacs, adding the following lines.  If you
don't know any of these editors, use `nano ~/.bashrc`.  Uncomment the line for the cluster you are on.  The `$CLUSTER` variable is used by several scripts.

```
# export CLUSTER="GAIA"
# export CLUSTER="COEUS"

export COMMON=~/common/install

export PATH=$COMMON/bin:$PATH

export LD_LIBRARY_PATH=$COMMON/lib:$LD_LIBRARY_PATH
if [ $CLUSTER == "GAIA" ]; then
	export LD_LIBRARY_PATH=/vol/apps/compilers/intel/2018/compilers_and_libraries_2018.1.163/linux/mkl/lib/intel64:$LD_LIBRARY_PATH
else
 	LD_LIBRARY_PATH=/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
fi

export PYTHONPATH=$HOME/local:$PYTHONPATH

module use --append $HOME/privatemodules
```

Source these changes by `source ~/.bashrc`

### Step 3

Run `install_cmake3 3.1.3` to install cmake3 in a 'common' directory 
in your $HOME folder (see the tree above).

Note: cmake 3.1.3 is not the latest version, but we need to install it first because the current version of cmake won't boostrap from the very old CMake on the Coeus or Gaia.

Now if you do `which cmake`, you should see
`~/common/install/bin/cmake`

and if you do cmake --version, you should see
cmake version 3.1.3

Now you're ready to install a higher CMake version by running the install script again.
Cmake 3.18.1 gave an error that gcc-9.2.0 doesn't support enough C++ 11.

On Coeus, you should be able to do:

`./install_cmake3 3.17.5`

On Gaia, because the openssl is so old (version 1.0.1e), the highest you can go is:

`./install_cmake3 3.15.7`

CMake versions available for download are listed here: 
[https://cmake.org/download/]

### Step 4

Install Python3

On Coeus, you should be able to do:

`./install_python3 3.8.6`

On Gaia, because of the old openssl, the highest you can go is:

`./install_python3 3.6.12`

Python versions for download are listed here:
[https://www.python.org/downloads/].

### Step 5 

pip3 install --update pip
pip3 install ipython numpy scipy sympy matplotlib pytest cxroots

### Step 6

Add private modules:

```
cp -r $HOME/coeus_ngsolve/privatemodules_coeus $HOME/privatemodules
```
or

```
cp -r $HOME/coeus_ngsolve/privatemodules_gaia $HOME/privatemodules
```

Edit the last line of each of the module files to ensure that the Python minor version (e.g. 3.8) associated with NGSolve matches the version you installed in Step 4.
 
The modules `ngsolve/serial`, `ngsolve/parallel` and `ngsolve/phi_serial` should now appear if you type `module avail`

### Step 7

Open `install_ngsolve_serial` in an editor to make sure the cmake command is to your liking.  The Pardiso sparse solver is recommended, but does not appear to be available on Gaia.  On Gaia, UMFPack should be enabled instead.

run `install_ngsolve_serial` to install the latest version of
Netgen/Ngsolve for serial processing.

To test the install, first do
`module load ngsolve/serial`
`module load gcc-9.2.0`

Then open a python or ipython console and try
`import ngsolve`

### Step 6

Make sure the `module load` commands above are present in your slurm batch script
Sample 'slurm_coeus' and 'slurm_gaia' scripts are provided here.  Then submit your job like this:
`sbatch slurm_gaia`

### Updating

To update NGSolve, simply delete the NGserial tree using `rm -rf NGserial`,
 and re-run `./install_ngsolve_serial`

Also you can re-run the `install_python` and `install_cmake` scripts at any time to update
those pre-requisites to any desired version.  It's not necessary to delete the previous
versions of these.

### Optional items

If you need to use NGSolve's capabilities for splitting the mesh among
 multiple MPI processes, run `./install_ngsolve_parallel`. 

If you need NGSolve special functions for serial or parallel mode, 
you can install the package using those provided scripts.

You can easily switch between the serial and parallel NGSolve installations
e.g. `$ module load ngsolve/parallel` using the module scripts in
privatemodules.

### Additional scripts

There are some additional scripts provided here for installing Petsc, 
ngs-petsc, and an NGSolve install for the Xeon Phi nodes.  Some additional
steps may be required for these.  Improved scripts and documentation
are a work in progress as the clusters evolve.

