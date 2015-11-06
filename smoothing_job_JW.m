%-----------------------------------------------------------------------
% Job saved on 18-Nov-2014 08:58:42 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
global subj

dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/';
%dataDirSW = '/Users/shararehn/Documents/Homeless2014/';

r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/wra*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
r1Scans=cellstr(r1Scans);

matlabbatch{1}.spm.spatial.smooth.data = r1Scans;
matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/wra*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
r2Scans=cellstr(r2Scans);

matlabbatch{2}.spm.spatial.smooth.data = r2Scans;
matlabbatch{2}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{2}.spm.spatial.smooth.dtype = 0;
matlabbatch{2}.spm.spatial.smooth.im = 0;
matlabbatch{2}.spm.spatial.smooth.prefix = 's';

r3scanfile = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/wra*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r3Scans=[repmat([dataDir 's' num2str(subj) '/func/run3/unwarped/' r3scanfile(1).name],219,1) commas volnums];
r3Scans=cellstr(r3Scans);

matlabbatch{3}.spm.spatial.smooth.data = r3Scans;
matlabbatch{3}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{3}.spm.spatial.smooth.dtype = 0;
matlabbatch{3}.spm.spatial.smooth.im = 0;
matlabbatch{3}.spm.spatial.smooth.prefix = 's';

r4scanfile = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/wra*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r4Scans=[repmat([dataDir 's' num2str(subj) '/func/run4/unwarped/' r4scanfile(1).name],219,1) commas volnums];
r4Scans=cellstr(r4Scans);

matlabbatch{4}.spm.spatial.smooth.data = r4Scans;
matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.im = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's';

