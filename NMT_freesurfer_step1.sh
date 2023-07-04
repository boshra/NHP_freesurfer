source parameters_NMT_freesurfer.sh

# create a folder for the freesurfer surfaces we will eventually end up with
mkdir -p ${fsSurf}

# make subfolders for structure

mkdir -p ${fsSurf_src}
mkdir -p ${fsSurf_mgz}
mkdir -p ${fsSurf_temp}

# copy the source files from the NMT segmentation to the freesurfer folders you just created
cp ${NMT_src}/single_subject_scans/${SUBJ}_aligned/${SUBJ}.nii.gz ${fsSurf_src}/T1.nii.gz
cp ${NMT_src}/single_subject_scans/${SUBJ}_aligned/${SUBJ}_ns.nii.gz ${fsSurf_src}/brain.nii.gz
cp ${NMT_src}/single_subject_scans/${SUBJ}_aligned/${SUBJ}_ns.nii.gz ${fsSurf_src}/brainmask.nii.gz # freesurfer brainmask aren't actually masks
cp ${NMT_src}/single_subject_scans/${SUBJ}_aligned/${SUBJ}_WM.nii.gz ${fsSurf_src}/wm.nii.gz

# copy source files again but keep these in original state 
# (for others the header will be changed to 'fake' 1 mm voxels, which is necessary for freesurfer)
mkdir -p ${fsSurf_src}/org
cp ${fsSurf_src}/*.nii.gz ${fsSurf_src}/org/






# change headers
3drefit -xdel 1.0 -ydel 1.0 -zdel 1.0 -keepcen ${fsSurf_src}/T1.nii.gz &
3drefit -xdel 1.0 -ydel 1.0 -zdel 1.0 -keepcen ${fsSurf_src}/brain.nii.gz &
3drefit -xdel 1.0 -ydel 1.0 -zdel 1.0 -keepcen ${fsSurf_src}/brainmask.nii.gz &
3drefit -xdel 1.0 -ydel 1.0 -zdel 1.0 -keepcen ${fsSurf_src}/wm.nii.gz &
# convert to mgz files for freesurfer
mri_convert -c ${fsSurf_src}/T1.nii.gz ${fsSurf_mgz}/T1.mgz &
mri_convert -c ${fsSurf_src}/brain.nii.gz ${fsSurf_mgz}/brain.mgz &
mri_convert -c ${fsSurf_src}/brain.nii.gz ${fsSurf_mgz}/brainmask.mgz &
mri_convert -c ${fsSurf_src}/brainmask.nii.gz ${fsSurf_mgz}/brainmask_binary.mgz &
mri_convert -c ${fsSurf_src}/wm.nii.gz ${fsSurf_mgz}/wm.mgz &
# create brain.finalsurfs.mgz
mri_mask -T 5 ${fsSurf_mgz}/brain.mgz ${fsSurf_mgz}/brainmask.mgz ${fsSurf_mgz}/brain.finalsurfs.mgz &



# Inspect volume to get voxel coordinates
freeview -v ${fsSurf_mgz}/brain.mgz &

