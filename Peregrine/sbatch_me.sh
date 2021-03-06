#!/bin/bash
# Call with e.g. 'sbatch ./sbatch_me do_simulation.R example1.RDa'
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100000
#SBATCH --job-name=article
#SBATCH --mail-type=BEGIN,END
module load R Beast
Rscript $1 $2