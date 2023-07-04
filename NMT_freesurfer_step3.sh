source parameters_NMT_freesurfer.sh

# look at the result and apply fixes in WM definition
# you will want to get rid of weird 'stalks' and 'bridges'
freeview -v ${fsSurf_mgz}/brain.mgz -v ${fsSurf_mgz}/wm.mgz \
    -f ${fsSurf_temp}/lh.smoothwm ${fsSurf_temp}/lh.inflated \
    ${fsSurf_temp}/rh.smoothwm ${fsSurf_temp}/rh.inflated & 
