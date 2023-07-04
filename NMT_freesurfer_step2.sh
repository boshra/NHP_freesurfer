source parameters_NMT_freesurfer.sh


# Fill WM
mri_fill -CV ${CC[0]} ${CC[1]} ${CC[2]} \
    -PV ${PONS[0]} ${PONS[1]} ${PONS[2]} \
    ${fsSurf_mgz}/wm.mgz ${fsSurf_mgz}/filled.mgz
# copy the original white matter before applying fixes    
cp ${fsSurf_mgz}/wm.mgz ${fsSurf_mgz}/wm_nofix.mgz

# Tesselate
# left hemisphere
mri_pretess ${fsSurf_mgz}/filled.mgz 255 ${fsSurf_mgz}/brain.mgz ${fsSurf_mgz}/wm_filled-pretess255.mgz
mri_tessellate ${fsSurf_mgz}/wm_filled-pretess255.mgz 255 ${fsSurf_temp}/lh.orig.nofix
# right hemisphere
mri_pretess ${fsSurf_mgz}/filled.mgz 127 ${fsSurf_mgz}/brain.mgz ${fsSurf_mgz}/wm_filled-pretess127.mgz
mri_tessellate ${fsSurf_mgz}/wm_filled-pretess127.mgz 127 ${fsSurf_temp}/rh.orig.nofix

# for both hemispheres
for xh in ${HEMI[@]}; do
    # create a version we can edit
    cp ${fsSurf_temp}/${xh}.orig.nofix ${fsSurf_temp}/${xh}.orig

    # post-process tesselation
    mris_extract_main_component ${fsSurf_temp}/${xh}.orig.nofix ${fsSurf_temp}/${xh}.orig.nofix
    mris_smooth -nw ${fsSurf_temp}/${xh}.orig.nofix ${fsSurf_temp}/${xh}.smoothwm.nofix
    mris_inflate ${fsSurf_temp}/${xh}.smoothwm.nofix ${fsSurf_temp}/${xh}.inflated.nofix
    mris_sphere -q ${fsSurf_temp}/${xh}.inflated.nofix ${fsSurf_temp}/${xh}.qsphere.nofix
    cp ${fsSurf_temp}/${xh}.inflated.nofix ${fsSurf_temp}/${xh}.inflated

    # fix topology
    mris_euler_number ${fsSurf_temp}/${xh}.orig
    mris_remove_intersection ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.orig
    mris_smooth -nw ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.smoothwm
    mris_inflate ${fsSurf_temp}/${xh}.smoothwm ${fsSurf_temp}/${xh}.inflated
done
