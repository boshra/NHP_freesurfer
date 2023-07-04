source parameters_NMT_freesurfer.sh

cd ${SUBJECTS_DIR}/${SUBJ}/surf/
mkdir -p gii
for xh in ${HEMI[@]}; do
    mris_convert ${xh}.white ./gii/${xh}.white.gii
    mris_convert ${xh}.graymid ./gii/${xh}.graymid.gii
    mris_convert ${xh}.pial ./gii/${xh}.pial.gii
    mris_convert ${xh}.inflated ./gii/${xh}.inflated.gii

    mris_convert ${xh}.smoothwm ./gii/${xh}.smoothwm.gii
    mris_convert ${xh}.smoothgraymid ./gii/${xh}.smoothgraymid.gii
    mris_convert ${xh}.smoothpial ./gii/${xh}.smoothpial.gii
    
    mris_convert -p -c ${xh}.curv ${xh}.full.patch.flat ./gii/${xh}.full.patch.flat.gii
    mris_convert -p -c ${xh}.curv ${xh}.occip.patch.flat ./gii/${xh}.occip.patch.flat.gii
done




cp -r ${SUBJECTS_DIR}/${SUBJ}/surf ${fsSurf}/surf
