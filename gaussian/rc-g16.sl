#!/bin/bash -l
#SBATCH --job-name=rc-g16		# The job name
#SBATCH --ntasks=1			# One task will be run
#SBATCH --cpus-per-task=16		# The task requires 16 CPUs
#SBATCH --hint=compute_bound		# Hyperthreading is enabled, run only on cores 
					#   - 32 total CPUs will be allocated for this job.
#SBATCH --mem-per-cpu=3500M		# Allocate 3.5GB of memory per CPU
					#   - 112GB = 32*3.5GB of memory will be allocated 
#SBATCH --time=0-00:10:00		# Max run time is 3 days, this test is 10min
					#   - Use --time as command line argument to override					
#SBATCH --partition=cpu-s6-test-0	# Submit job to the cpu test partition
#SBATCH --account=cpu-s6-test-0		# and cpu test account
#SBATCH --mail-type=ALL			# Send mail on all state changes
#SBATCH --output=%x.%j.out		# The output file name: <job_name>.<job_id>.out
#SBATCH --error=%x.%j.err		# The error file name: <job_name>.<job_id>.err

#--------------------------------------------------------------------------------------------------
#
# Name: rc-g16
#
# Purpose: Run a containerized Gaussian 16 job.
#
# Input: This batch script takes a Gaussian input file as an argument.
#
# Output: Output files will be written to the working directory from which the batch script was
#         submitted. The stdout file name ends in *.out. The stderr file name ends in *.err.
#         Both contain the job number.
#
# Notes: This submission script is optimized for 16 core, 112GB memory jobs. Please ensure your
#        Gaussian input file matches these dimensions. Dimensions may, optionally, be overriden
#        from the command line. See the example below.
#
# Example submission:
#
# $ sbatch rc-g16.sl input.gjf
#
# Example submission that changes maximum run time and sets a notification email address:
#
# $ sbatch --time=10-00:00:00 --mail-user=jdredd@unr.edu rc-g16.sl input.gjf
#
#--------------------------------------------------------------------------------------------------

# Load the unr-rc module to gain access to the singularity container module
module load unr-rc
# Load the singularity container module
module load singularity

# Error if the Gaussian input file does not exist or was not specified. Check stderr file for 
# error.
[[ -f ${1} ]] || { echo "Gaussian input file does not exist" >&2; exit 1; }

# Run Gaussian from the system singularity container with the Gaussian input file specified from
# the command line.
srun singularity exec /apps/gaussian/16/gaussian16-centos7.4.simg g16 < ${1}
