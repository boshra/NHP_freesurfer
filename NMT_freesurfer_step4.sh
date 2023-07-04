source parameters_NMT_freesurfer.sh

# redo the tesselation with the freshly fixed WM volume
mri_fill -CV ${CC[0]} ${CC[1]} ${CC[2]} \
    -PV ${PONS[0]} ${PONS[1]} ${PONS[2]} \
    ${fsSurf_mgz}/wm.mgz ${fsSurf_mgz}/filled.mgz
    
mri_pretess ${fsSurf_mgz}/filled.mgz 255 ${fsSurf_mgz}/brain.mgz ${fsSurf_mgz}/wm_filled-pretess255.mgz
mri_tessellate ${fsSurf_mgz}/wm_filled-pretess255.mgz 255 ${fsSurf_temp}/lh.orig
mri_pretess ${fsSurf_mgz}/filled.mgz 127 ${fsSurf_mgz}/brain.mgz ${fsSurf_mgz}/wm_filled-pretess127.mgz
mri_tessellate ${fsSurf_mgz}/wm_filled-pretess127.mgz 127 ${fsSurf_temp}/rh.orig

for xh in ${HEMI[@]}; do
    mris_extract_main_component ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.orig
    mris_smooth -nw ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.smoothwm
    mris_inflate ${fsSurf_temp}/${xh}.smoothwm ${fsSurf_temp}/${xh}.inflated
    mris_sphere -q ${fsSurf_temp}/${xh}.inflated ${fsSurf_temp}/${xh}.qsphere
    
    mris_euler_number ${fsSurf_temp}/${xh}.orig
    mris_remove_intersection ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.orig
    mris_smooth -nw ${fsSurf_temp}/${xh}.orig ${fsSurf_temp}/${xh}.smoothwm
    mris_inflate ${fsSurf_temp}/${xh}.smoothwm ${fsSurf_temp}/${xh}.inflated
    mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ${fsSurf_temp}/${xh}.inflated
done


# look at the result and apply fixes in WM definition
# you will want to get rid of weird 'stalks' and 'bridges'
freeview -v ${fsSurf_mgz}/brain.mgz -v ${fsSurf_mgz}/wm.mgz \
    -f ${fsSurf_temp}/lh.smoothwm ${fsSurf_temp}/lh.inflated \
    ${fsSurf_temp}/rh.smoothwm ${fsSurf_temp}/rh.inflated & 

 
