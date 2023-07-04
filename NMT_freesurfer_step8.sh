source parameters_NMT_freesurfer.sh

# right
#tksurfer ${SUBJ} rh inflated -curv
tksurfer ${SUBJ} rh inflated -gray&


tksurfer ${SUBJ} lh inflated -gray&
