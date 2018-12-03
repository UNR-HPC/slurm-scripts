#!/bin/bash -l
#SBATCH --job-name=rc-cp2k		# The job name
#SBATCH --ntasks=16			# Number of tasks to run
#SBATCH --hint=compute_bound		# Hyperthreading is enabled, run only on cores
					#   - 32 total CPUs will be allocated for this job
#SBATCH --mem-per-cpu=5250M		# Allocate 5.25GB of memory per CPU
					#   - 84GB = 16*5.25GB of memory will be allocated 
#SBATCH --time=14-00:00:00		# Max run time is 14 days
					#   - Use --time as command line argument to override
#SBATCH --partition=cpu			# Submit job to the cpu partition
#SBATCH --mail-type=ALL			# Send mail on all state changes
#SBATCH --output=%x.%j.out		# The output file name: <job_name>.<job_id>.out
#SBATCH --error=%x.%j.err		# The error file name: <job_name>.<job_id>.err

#
# All SBATCH directives above this line specify resources
#--------------------------------------------------------------------------------------------------
#
# Name: rc-cp2k.sl
#
# Purpose: Run a containerized cp2k job
#
# Input: This batch script takes a cp2k input file as an argument
#
# Output: Output files will be written to the working directory from which the batch script was
#         submitted. The stdout file name is of the form <job_name>.<job_id>.out. The stderr file
#         name is of the form <job_name>.<job_id>.err. Both contain the job name & job number.
#
# Notes: 
#        This version of cp2k is installed a in Singularity container.
#
#        The cp2k.popt binary is being used - parallel (only MPI) general usage, no threads. 
#
#        This submission script is optimized for 16 core, 84GB memory jobs. The amount of 
#        memory is based on the lowest amount of RAM per CPU on pronghorn nodes at the time
#        of writing (5.25GB).
#
#        Specifying a square number of tasks (MPI ranks) is recommended for best performance of
#        the libDBCSR component of cp2k.
#
#        Dimensions may optionally be overridden from the command line. See the examples below.
#
# Example submission:
#
# $ sbatch rc-cp2k.sl ccm.inp
#
# Example submission that changes maximum run time and sets a notification email address:
#
# $ sbatch --time=10-00:00:00 --mail-user=jdredd@unr.edu rc-cp2k.sl ccm.inp
#
# Example submission that changes the number of tasks:
#
# $ sbatch --ntasks=64 rc-cp2k.sl ccm.inp
#--------------------------------------------------------------------------------------------------

# Load the unr-rc module to gain access to the singularity container module
module load unr-rc
# Load the singularity container module
module load singularity
# Load the cp2k 5.1 container module & its dependants (Intel 2017.5.239 MKL, MPI)
module load cp2k/5.1

# Error if the cp2k input file does not exist or was not specified. Check stderr file for 
# error.
[[ -f ${1} ]] || { echo "cp2k input file does not exist" >&2; exit 1; }

# Run cp2k from the system singularity container with the input file specified from
# the command line. /cm/shared needs to be bind mounted to access Intel MKL & MPI.
mpirun singularity exec -B /cm/shared /apps/cp2k/cp2k5.1-plumed2.2.5.simg cp2k.popt -i ${1}