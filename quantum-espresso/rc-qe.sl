#!/bin/bash -l
#SBATCH --job-name=rc-QE                # The job name
#SBATCH -N 1                            # Request entire nodes, QE runs mixed openMP/MPI
#SBATCH --tasks-per-node=32             # 32 tasks per node
#SBATCH --time=14-00:00:00              # Max run time is 14 days
                                        #   - Use --time as command line argument to override
#SBATCH --partition=cpu                 # Submit job to the cpu partition
#SBATCH --mail-type=ALL                 # Send mail on all state changes
#SBATCH --output=%x.%j.out              # The output file name: <job_name>.<job_id>.out
#SBATCH --error=%x.%j.err               # The error file name: <job_name>.<job_id>.err

#
# All SBATCH directives above this line specify resources
#--------------------------------------------------------------------------------------------------
#
# Name: rc-qe.sl
#
# Purpose: Run a containerized Quantum-Espresso (QE) job
#
# Input: This batch script takes a QE input file as an argument
#
# Output: Output files will be written to the working directory from which the batch script was
#         submitted. The stdout file name is of the form <job_name>.<job_id>.out. The stderr file
#         name is of the form <job_name>.<job_id>.err. Both contain the job name & job number.
#
# Notes: 
#
#        This submission script is optimized for entire compute nodes performing geometry optimization
#        calculations using PW parallelization.
#
#        Dimensions may optionally be overridden from the command line. See the examples below.
#
#        Job dimensions for PH 1st generation compute nodes Intel E5-2683 v4 (Broadwell)
#
# Example submission:
#
# $ sbatch rc-qe.sl opt.inp
#
# Example submission that changes maximum run time and sets a notification email address:
#
# $ sbatch --time=10-00:00:00 --mail-user=jdredd@unr.edu rc-qe.sl opt.inp
#
# Example submission that changes the number of nodes:
#
# $ sbatch --nodes=4 rc-qe.sl opt.inp
#--------------------------------------------------------------------------------------------------

# Load the unr-rc module to gain access to the singularity container module
module load unr-rc
# Load the singularity container module
module load singularity

# Error if the QE input file does not exist or was not specified. Check stderr file for error
[[ -f ${1} ]] || { echo "QE input file does not exist" >&2; exit 1; }

# for srun
export I_MPI_PMI_LIBRARY=/cm/shared/apps/slurm/17.02.2/lib64/libpmi.so

# number of openMP threads per MPI process
export OMP_NUM_THREADS=1

# Run QE from the system singularity container with the input file specified from
# the command line. 
srun --mpi=pmi2 singularity exec /apps/quantum-espresso/QuantumESPRESSO-6.3-intel-2018b-eb.sif pw.x -inp ${1}
