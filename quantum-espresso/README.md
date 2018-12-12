### The rc-qe.sl script is written to take a Quantum-Espresso (QE) input file as an argument. It will dump its output into the directory from which it was invoked. The following are some use cases for this script:

###### Notes:

* This script will run a job on an entire compute node: 32 processor cores & approximately 90% of total memory
* Specify more than one node with -N option (example: -N 4 for 4nodes x 32 MPI tasks = 128 MPI tasks)
* This script is optimized for entire compute nodes performing geometry optimization calculations using PW parallelization

###### Simple invocation

script will be executed from the current working directory

input file will be read from the current working directory

output to the current working directory

$ sbatch rc-qe.sl input-file.inp

###### Invoke script from a shared location

script will be executed from an installation directory

input file will be read from the current working directory

output to the current working directory

$ sbatch /path/to/script/rc-qe.sl input-file.inp

###### Everything variable

script will be executed from an installation directory

input file will be read from an input directory

output to the current working directory

$ mkdir output $ cd output $ sbatch /path/to/script/rc-qe.sl /path/to/input/input-file.inp

###### Change run time from command line

no need to edit the script to change sbatch parameters

$ sbatch --time=10-00:00:00 rc-qe.sl input-file.inp

###### Set an email for notification on job state change from command line

$ sbatch --mail-user=jdredd@unr.edu rc-qe.sl input-file.inp

###### Change the job name and run time from the command line

$ sbatch --job-name=my-qe-job --time=02:00:00 rc-qe.sl input-file.inp

###### Change the number of compute nodes from the command line

$ sbatch --nodes=4 rc-qe.sl input-file.inp
