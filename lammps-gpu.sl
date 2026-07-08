#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time 10:00:00
#SBATCH --gres=gpu:1
#SBATCH --account=gpu-s2-oit-0          # The account to charge
#SBATCH --partition=gpu-s2-core-0       # The partition
set -e; set -o pipefail

# Load required modules
module load singularity

# Build container if it doesn't exist
if [[ ! -f lammps.sif ]]; then
    singularity build lammps.sif docker://nvcr.io/hpc/lammps:29Oct2020
fi

readonly gpus_per_node=$(( SLURM_NTASKS / SLURM_JOB_NUM_NODES  ))

echo "Running Lennard Jones 8x4x8 example on ${SLURM_NTASKS} GPUS..."
srun --mpi=pmi2 \
singularity run --nv -B ${PWD}:/host_pwd  lammps.sif \
lmp -k on g ${gpus_per_node} -sf kk -pk kokkos cuda/aware on neigh full comm device binsize 2.8 -var x 8 -var y 8 -var z 8 -in /host_pwd/in.lj.txt
