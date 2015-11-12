#!/bin/bash
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100000
#SBATCH --job-name=real_job_2
#SBATCH --mail-type=BEGIN,END
module load R beagle-lib Beast
Rscript run.R