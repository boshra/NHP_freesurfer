SUBJ=freddie
fslmaths NMT_v2.0_sym_segmentation_in_freddie.nii.gz -thr 0.9 -uthr 1.1 -bin ${SUBJ}_CSF.nii.gz
fslmaths NMT_v2.0_sym_segmentation_in_freddie.nii.gz -thr 1.9 -uthr 2.1 -bin ${SUBJ}_GM.nii.gz
fslmaths NMT_v2.0_sym_segmentation_in_freddie.nii.gz -thr 2.9 -uthr 4.1 -bin ${SUBJ}_WM.nii.gz
fslmaths NMT_v2.0_sym_segmentation_in_freddie.nii.gz -thr 0.5 -uthr 4.1 -bin ${SUBJ}_brainmask.nii.gz
