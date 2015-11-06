% Wrapper to run alphasim, with info needed from any SPM folder
%
% function runAlphasim(directory,thr)
% 
% input directory: directory of SPM.mat file
% thr: vectors of voxel-wise p thresholds

function runAlphasimJW(directory,thr)

spmfile=load([directory '/SPM.mat']);
dim=spmfile.SPM.xVol.DIM';
opts.fwhm=spmfile.SPM.xVol.FWHM;
%nii = load_nii([directory '/mask.img']);
%mask = nii.img;
nii = load_nii([directory '/mask.nii']);
mask = nii.img;
%[mask hdr]=cbiReadNifti([directory '/mask.img']);
opts.mask=logical(mask);
opts.thr=thr; 
alphasim(dim,opts)

end

%patientss(:,:,:,1)=niftiread('P41_MNI-mask.nii');
%p2=load_nii(');
%patientss(:,:,:,p)=p2.img;