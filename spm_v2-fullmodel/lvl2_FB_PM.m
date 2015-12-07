% List of open inputs
clear all
close all
nrun = 1; % enter the number of runs here
spm_jobman('initcfg')

% jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_FB_PM_IncG_GvK_job.m'};
% jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_FB_PM_GvK_job.m'};
% jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_FB_PM_IncG_G_job.m'};
jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_FB_PM_IncG_K_job.m'};
% jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_FB_PM_incGiv_job.m'};

jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
