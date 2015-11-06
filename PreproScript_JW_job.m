%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
% Original script by Leor, modified by Sharareh on Nov 11, 2014
% Modified by Julian on Oct 29, 2015
%-----------------------------------------------------------------------
%% 
global subj
global deleteLast

% subj=1;
% run=[1 2 3 4];

dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/';
% if strncmpi(matlabroot, 'C:\', 3)==1 %if on windows, change file path
%     dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
% end

%dataDirSN = '/Users/shararehn/Documents/Homeless2014/'; 

r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/1*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
r1Scans=cellstr(r1Scans);


r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/1*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
r2Scans=cellstr(r2Scans);

r3scanfile = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/1*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r3Scans=[repmat([dataDir 's' num2str(subj) '/func/run3/unwarped/' r3scanfile(1).name],219,1) commas volnums];
r3Scans=cellstr(r3Scans);


r4scanfile = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/1*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r4Scans=[repmat([dataDir 's' num2str(subj) '/func/run4/unwarped/' r4scanfile(1).name],219,1) commas volnums];
r4Scans=cellstr(r4Scans);


anatFile=dir([dataDir 's' num2str(subj) '/anat/unwarped/*.nii']);
anatScan=[dataDir 's' num2str(subj) '/anat/unwarped/' anatFile(1).name ',1'];
anatScan=cellstr(anatScan);
%%
% Time slicing
matlabbatch{1}.spm.temporal.st.scans = {r1Scans r2Scans r3Scans r4Scans};
matlabbatch{1}.spm.temporal.st.nslices = 34;
matlabbatch{1}.spm.temporal.st.tr = 2;
matlabbatch{1}.spm.temporal.st.ta = 1.941;
matlabbatch{1}.spm.temporal.st.so = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33];
matlabbatch{1}.spm.temporal.st.refslice = 1;
matlabbatch{1}.spm.temporal.st.prefix = 'a';
% Realign
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estwrite.data{2}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estwrite.data{3}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estwrite.data{4}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{4}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
% coregister
matlabbatch{3}.spm.spatial.coreg.estimate.ref = anatScan;
matlabbatch{3}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{3}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{3}.spm.spatial.coreg.estimate.other(2) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','rfiles'));
matlabbatch{3}.spm.spatial.coreg.estimate.other(3) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 3)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','rfiles'));
matlabbatch{3}.spm.spatial.coreg.estimate.other(4) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 4)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{4}, '.','rfiles'));
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

% Normalization
matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.source = anatScan;
matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.template = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/SPMOldNormT1.nii,1'}; %% Change this directory if need be!!
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 40;
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.nits = 8;
matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -50
                                                        78 76 85];
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.vox = [3 3 3];
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';
