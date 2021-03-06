#!/bin/sh

#SBATCH --partition=$PART
#SBATCH --ntasks=$NN
#SBATCH --tasks-per-node=24
#SBATCH --job-name=pism-a$runnum
#SBATCH --account=ICESHEET
#SBATCH --mail-user=acjohnson16@alaska.edu
#SBATCH --output=logs/pismlog.%j

umask 007
ulimit -s unlimited
ulimit -l unlimited

# Load any desired modules, usually the same as loaded to compile
. /etc/profile.d/modules.sh
# module purge
# module load toolchain/pic-intel/2016b
# module load slurm

cd $SLURM_SUBMIT_DIR
# Generate a list of allocated nodes; will serve as a machinefile for mpirun
srun -l /bin/hostname | sort -n | awk '{print $2}' > ./nodes.$SLURM_JOB_ID
# Launch the MPI application

mpiexec -n $NN -machinefile ./nodes.$SLURM_JOB_ID pismr -i $Inspin \
  -Mx $mx -My $my -Mz 121 -Lz 6000 -MBz 31 -LBz 2000 \
  -z_spacing quadratic -zb_spacing equal \
  -skip -skip_max 20 \
  -bed_smoother_range 5e3 \
  -grid.correct_cell_areas false -grid.registration corner \
  -ys -$Yst -ye $Yet \
  -surface given -surface_given_file $Inboot \
  -atmosphere given -atmosphere_given_file $Atmofile \
  -ocean $otype $ostr \ 
  -sia_e $SIAe -ssa_e $SSAe -stress_balance ssa+sia \
  -topg_to_phi $TGPhi -pseudo_plastic -pseudo_plastic_q $PPQ \
  -pseudo_plastic_uthreshold $PPUt \
  -till_effective_fraction_overburden $TEFO \
  $calvstr \
  -eigen_calving_K $ecalvK -thickness_calving_threshold $tcalvt \
  -pik $misc\
  -ts_file $Outexts_$Outfm -ts_times -$Yst:yearly:$Yet \
  -extra_file $Outexex_$Outfm -extra_times -$Yst:50:$Yet \
  -extra_vars diffusivity,temppabase,tempicethk_basal,bmelt,tillwat,velsurf_mag,mask,thk,topg,usurf,hardav,velbase_mag,tauc,tendency_of_ice_amount_due_to_discharge,dHdt \
  -o $Outloc$Outfm -

# Clean up the machinefile
rm ./nodes.$SLURM_JOB_ID

#  -tauc_slippery_grounding_lines \
