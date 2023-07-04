source parameters_NMT_freesurfer.sh


# create the spheres (this takes longer so do it only when you're happy with the inflated)
for xh in ${HEMI[@]}; do
    mris_sphere ${fsSurf_temp}/${xh}.inflated ${fsSurf_temp}/${xh}.sphere &
done


# create a freesurfer SUBJECT with the correct folder structure
# NB! $SUBJECTS_DIR should be defined in your ~/.bashrc as the Freesurfer subjects directory
echo 'Creating a subject directory for '${SUBJ} 'in:'
echo ${SUBJECTS_DIR}/${SUBJ}
mksubjdirs ${SUBJECTS_DIR}/${SUBJ}


# copy the necessary files for cutting to the subject directory
for xh in ${HEMI[@]}; do
    cp ${fsSurf_temp}/${xh}.inflated ${SUBJECTS_DIR}/${SUBJ}/surf/
    cp ${fsSurf_temp}/${xh}.smoothwm ${SUBJECTS_DIR}/${SUBJ}/surf/
    cp ${fsSurf_temp}/${xh}.orig ${SUBJECTS_DIR}/${SUBJ}/surf/
    cp ${fsSurf_temp}/${xh}.qsphere ${SUBJECTS_DIR}/${SUBJ}/surf/
done

cp ${fsSurf_mgz}/T1.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/T1.mgz
cp ${fsSurf_mgz}/filled.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/filled.mgz
cp ${fsSurf_mgz}/wm.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/wm.mgz
cp ${fsSurf_mgz}/brain.finalsurfs.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/brain.finalsurfs.mgz
cp ${fsSurf_mgz}/brainmask.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/brainmask.mgz



# Make a folder for this procedure and convert the necessary files to nifti so we can use `fslmaths`
mkdir -p $fsSurf/enh
mri_convert ${fsSurf_mgz}/brain.mgz $fsSurf/enh/brain.nii.gz 
mri_convert ${fsSurf_mgz}/wm.mgz $fsSurf/enh/wm.nii.gz 

# binarize the wm volume
fslmaths $fsSurf/enh/wm.nii.gz -bin $fsSurf/enh/wm_bin.nii.gz

# divide the voxel value in the original brain volume by **some** value and add **another** value to the white matter only 
# which values you need here is up to you but we want to end with white matter voxels having a value ~110 and grey matter ~60-80
# alternative ways are definitely possible as long as your end result is similar
fslmaths $fsSurf/enh/brain.nii.gz -div 2 $fsSurf/enh/brain2.nii.gz
fslmaths $fsSurf/enh/wm_bin.nii.gz -mul 20 $fsSurf/enh/wm_add.nii.gz
fslmaths $fsSurf/enh/brain2.nii.gz -add $fsSurf/enh/wm_add.nii.gz $fsSurf/enh/brain_enh.nii.gz

# convert the 'enhanced' brain back to mgz
mri_convert $fsSurf/enh/brain_enh.nii.gz ${SUBJECTS_DIR}/${SUBJ}/mri/brain_enh.mgz



# create surfaces
# this will take a while. don't wait for it. go get a coffee, call your mother, or read a paper.
for xh in ${HEMI[@]}; do
    mris_make_surfaces -noaseg -noaparc -T1 brain_enh -orig_wm orig ${SUBJ} ${xh}
    mris_sphere ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.inflated ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.sphere
done



# freeview -f ${fsSurf_temp}/lh.smoothwm ${fsSurf_temp}/lh.inflated ${fsSurf_temp}/lh.sphere &
freeview -f ${SUBJECTS_DIR}/${SUBJ}/surf/lh.smoothwm ${SUBJECTS_DIR}/${SUBJ}/surf/lh.inflated ${SUBJECTS_DIR}/${SUBJ}/surf/lh.sphere &

