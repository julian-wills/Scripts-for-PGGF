% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/smoothing_job_JW.m'};
%jobfileSW = {'/Users/shararehn/Documents/Homeless2014/batchFiles/smoothing_job_JW.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '',inputs{:});
