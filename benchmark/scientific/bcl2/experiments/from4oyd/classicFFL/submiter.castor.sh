#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --job-name="classicFFL"
#SBATCH --time 45:00:00
#SBATCH --array=1-1000
#SBATCH --output=/scratch/bonet/logs/classicFFL.%A_%a.out
#SBATCH --error=/scratch/bonet/logs/classicFFL.%A_%a.err

ROSETTAPATH="/scratch/lpdi/bin/Rosetta/devel/nubinitio/main/source/bin/"
ROSETTADIST="linuxiccrelease"
EXPCOMPLEMENT="classicFFL"
JOBID=1
ROUND=${SLURM_ARRAY_TASK_ID}
TARGET="design"

WITHBINDER="nobinder"
if [ ${SLURM_ARRAY_TASK_ID} -gt 500 ]; then
    WITHBINDER="binder"
fi

SUFFIX=${EXPCOMPLEMENT}_${JOBID}_${ROUND}
OUTDIR=${WITHBINDER}
INSILENT=../fullcst/${WITHBINDER}/nodesign_${WITHBINDER}_1_${ROUND}
mkdir -p ${OUTDIR}

srun ${ROSETTAPATH}rosetta_scripts.${ROSETTADIST} -parser:protocol ${TARGET}.${EXPCOMPLEMENT}.xml @common_flags -in:file:silent ${INSILENT} -out:suffix _${SUFFIX} -out:file:silent ${OUTDIR}/${TARGET}_${SUFFIX}

echo "CASTOR: RUN FINISHED"
