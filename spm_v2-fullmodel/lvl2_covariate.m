% List of open inputs
clear all
close all

spm_jobman('initcfg');
nrun = 1; % enter the number of runs here
jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl2_covariate_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
