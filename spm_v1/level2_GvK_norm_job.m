%-----------------------------------------------------------------------
% Job saved on 15-Sep-2015 15:10:04 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
% Purpose: include as many subjects as possible. Only Vet vs. Nonvet Stim.
% No Donation in model. 
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/Pro_v_Anti'};
%%
%exclude: subjects 2, 5, 9, 10, 11, 27, 36, 40, 42

subs = [1:47]; %4

c=[];
b=0;
clear d
for s=1:length(subs)
    
%     s=1;

    f=[];
    a=[];
    d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask'];
    a=dir(d{s});

    
    for i=1:length(a)
        if strfind(a(i).name,'con_PROvANTI')==1
            b=b+1;
            c{b}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask/',a(i).name];
        end
    end
%     c{s}=['/Users/Julian/GDrive/PGGfMRI/Neuro/Data/s',num2str(subs(s)),'/results/',f{b}];


end
c=c';

matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = c;
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans
%  
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/Users/julian/Downloads/mask20_no_eyeballs_roi/mask20_no_eyeballs.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;




