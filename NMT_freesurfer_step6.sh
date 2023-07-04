source parameters_NMT_freesurfer.sh



# check and edit the pial surface
mkdir -p ${SUBJECTS_DIR}/${SUBJ}/pial_edits # create a folder for pial edits
cp -R ${SUBJECTS_DIR}/${SUBJ}/mri ${SUBJECTS_DIR}/${SUBJ}/pial_edits/ 
cp -R ${SUBJECTS_DIR}/${SUBJ}/surf ${SUBJECTS_DIR}/${SUBJ}/pial_edits/



freeview -v ${SUBJECTS_DIR}/${SUBJ}/pial_edits/mri/T1.mgz ${SUBJECTS_DIR}/${SUBJ}/pial_edits/mri/brain_enh.mgz \
    -f ${SUBJECTS_DIR}/${SUBJ}/pial_edits/surf/lh.white:edgecolor=yellow ${SUBJECTS_DIR}/${SUBJ}/pial_edits/surf/lh.pial:edgecolor=red \
    ${SUBJECTS_DIR}/${SUBJ}/pial_edits/surf/rh.white:edgecolor=yellow ${SUBJECTS_DIR}/${SUBJ}/pial_edits/surf/rh.pial:edgecolor=red &

