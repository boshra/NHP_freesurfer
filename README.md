# NHP_freesurfer
Step-by-step shell scripts to generate surfaces for NHPs, mostly copied from PRIME-RE resource [https://github.com/VisionandCognition/NHP-Freesurfer]

Steps: 
------
1. Run @animal_warper on the T1 scan (tested using NMTv2.0, D99). Make sure segmentation is selected as a follow-dset.
2. Use itksnap to correct if the segmentations are not correct then run the NHP_freesurfer_segmentation script
3. Run steps 1-10, adjusting using the GUI as needed
