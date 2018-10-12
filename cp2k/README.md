### This script is written to take a cp2k input file as an argument. It will dump its output into the directory from which it was invoked. The following are some use cases for this script:

###### Notes:
* This script will run a 16 core job on up to 84GB of memory
* CPU affinity cannot be used with this script at this time

###### Simple invocation
script will be executed from the current working directory

input file will be read from the current working directory

output to the current working directory
> $ sbatch rc-cp2k.sl input-file.inp

###### Invoke script from a shared location
script will be executed from an installation directory

input file will be read from the current working directory

output to the current working directory
> $ sbatch /path/to/script/rc-cp2k.sl input-file.inp

###### Everything variable
script will be executed from an installation directory

input file will be read from an input directory

output to the current working directory
> $ mkdir output $ cd output $ sbatch /path/to/script/rc-cp2k.sl /path/to/input/input-file.inp

###### Change run time from command line
no need to edit the script to change sbatch parameters
> $ sbatch --time=10-00:00:00 rc-cp2k.sl input-file.inp

###### Set an email for notification on job state change from command line
> $ sbatch --mail-user=<netid>@unr.edu rc-cp2k.sl input-file.inp

###### Change the job name and run time from the command line
> $ sbatch --job-name=my-cp2k-job --time=02:00:00 rc-cp2k.sl input-file.inp

###### Change the number of tasks from the command line
 > $ sbatch --ntasks=64 rc-cp2k.sl input-file.inp                                                                                      1,44          Top
