source parameters_NMT_freesurfer.sh


# Time for another coffee, you are not going to want to wait for this to finish while staring at its progress
cd ${SUBJECTS_DIR}/${SUBJ}/surf/
for xh in ${HEMI[@]}; do
    mris_flatten -w 0 -distances 20 7 ${xh}.full.patch.3d  ${xh}.full.patch.flat
    mris_flatten -w 0 -distances 20 7 ${xh}.occip.patch.3d  ${xh}.occip.patch.flat
done

