% List of open inputs
clear all
close all
nrun = 1; % enter the number of runs here
spm_jobman('initcfg')
jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v1/level2_GvK_v1_eMask_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
