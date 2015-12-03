%-----------------------------------------------------------------------
% Job saved on 15-Sep-2015 15:10:04 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
% Purpose: Simple contrast between Give and Keep. Takes average across runs
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/choiceDur_norm'};


subs = [1 4 6:8 11:18 20:26 28:35 37:39 41 43:47]; %full model subs

subs= [1 3:4 6:8 11:26 28:35 37:39 41 43:47];

for s=1:length(subs)
    f=[];
    a=[];
    b=0;
    d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask/choiceDur'];
    a=dir(d{s});
    for i=1:length(a)
        if strfind(a(i).name,'con')==1
            b=b+1;
            f{b}=a(i).name;
        end
    end
    c{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask/choiceDur/',f{b},',1'];
%     strfind(a(:).name,'spm')
end

matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = c';

matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% subs = 1:30;
% for i=1:length(subs)
%     sub=subs(i);
%     subPath=[rootFolder '/S' num2str(sub)]; % Or whatever naming convention
%     cd(subPath);
%     spm_imcalc_ui([img1;img2],'OutputFilename.img','i1-i2');
%     cd(rootFolder);
% end
