export CLUSTER="COEUS"
# export CLUSTER="GAIA"

# Common installation folder
export COMMON_INSTALL_DIR=$HOME/common/install
export PATH=$COMMON_INSTALL_DIR/bin:$PATH
export LD_LIBRARY_PATH=$COMMON_INSTALL_DIR/lib:$LD_LIBRARY_PATH

# Local folder for python projects
export PYTHONPATH=$HOME/local:$PYTHONPATH

export PYTHONPATH=$HOME/software/PETSc/install/lib:$PYTHONPATH
export PYTHONPATH=$HOME/software/SLEPc/release-cuda/lib:$PYTHONPATH
module use --append $HOME/privatemodules

### USER_DEF FUNCTIONS
function reminders {
    echo ---
    echo -Print this with reminders
    echo -Activate venv with <name_alias_venv>
    echo -Deactivate any venv with d
    echo -Export local PETSc arch with release-cuda
    echo -Load NGS Modules with load-modules
    echo ---
}

function load-modules {
    echo "Loading modules..."
    # TODO Set and if for the different clusters in here!
    module purge
    module load intel
    module load Utils/lapack/3.8.0/gcc-8.2.0
    module load Utils/lapack-BLAS/3.8.0/gcc-8.2.0
    module load openmpi-4.1.4/gcc-12.1.0
    module load openmpi-4.1.4/gcc-12.1.0-cuda
    module load Utils/openssl/1.1.1t/gcc-12.1.0
    module load Utils/openssl/3.0.8/gcc-12.1.0
    module load gcc-12.1.0
    module list
    echo "Done!"
} 

# TODO PETSc, SLEPc
# These should be modules, cf. NGSolve
# export PETSC_DIR=$HOME/software/PETSc
# export SLEPC_DIR=$HOME/software/SLEPc
