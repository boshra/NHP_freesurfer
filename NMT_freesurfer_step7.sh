source parameters_NMT_freesurfer.sh





# NB! If you adjustments to the brainmask (which probably isn't necessary if NMT segmentation worked well) 
# don't forget to copy back the adjusted brain_enh for re-generation of the pial surface 
cp ${SUBJECTS_DIR}/${SUBJ}/pial_edits/mri/brain_enh.mgz ${SUBJECTS_DIR}/${SUBJ}/mri/brain_enh.mgz


# regenerate the pial surface
for xh in ${HEMI[@]}; do
    mris_make_surfaces  -noaseg -noaparc -orig_white white -orig_pial white -nowhite -mgz -T1 brain_enh ${SUBJ} ${xh}
done



# create midcortical surface by growing the white matter halfway towards the pial surface
for xh in ${HEMI[@]}; do
    mris_expand -thickness ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.white 0.5 ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.graymid
done

# Fix topology, smooth & inflate the final surfaces
for xh in ${HEMI[@]}; do    
    mris_euler_number ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.white
    mris_remove_intersection ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.white ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.white
    mris_smooth -n 3 -nw ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.white ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.smoothwm
    
    mris_euler_number ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.pial
    mris_remove_intersection ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.pial ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.pial
    mris_smooth -n 3 -nw ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.pial ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.smoothpial
    
    mris_euler_number ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.graymid
    mris_remove_intersection ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.graymid ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.graymid
    mris_smooth -n 3 -nw ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.graymid ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.smoothgraymid
    
    mris_inflate ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.smoothwm ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.inflated
    mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.inflated
    mris_sphere ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.inflated ${SUBJECTS_DIR}/${SUBJ}/surf/${xh}.sphere
done
