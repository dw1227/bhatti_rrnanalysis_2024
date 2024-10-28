#!/bin/bash
#SBATCH --job-name=easvs_make             # Name of your job
#SBATCH -q primary                        # specify partition
#SBATCH --output=easvs_output_%j.log      # Standard output log file (%j expands to job ID)
#SBATCH --error=easvs_errors_%j.log       # Standard error log file (%j expands to job ID)
#SBATCH --ntasks=1                        # Number of tasks (commands) to run
#SBATCH --cpus-per-task=8                 # Number of CPU cores per task
#SBATCH --mem=100G                        # Memory requirement per node
#SBATCH --time=4-00:00:00                 # Time limit (4 days)
#SBATCH --mail-type=ALL                   # Send email notifications for job events
#SBATCH --mail-user=dw1227@wayne.edu      # Your email address

# Change to the directory where the Makefile is located
cd /wsu/home/dw/dw12/dw1227/Documents/bhatti_rrnanalysis_2024

# Run make to build easvs
# make easvs
make exploratory/2024-10-13-threshold-to-drop-n-asvs.md
