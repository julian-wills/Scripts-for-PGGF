% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v1/level2_GvK_v1_noiMask_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
