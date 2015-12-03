% List of open inputs
% fMRI model specification: Directory - cfg_files
% fMRI model specification: Units for design - cfg_menu
% fMRI model specification: Interscan interval - cfg_entry
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Value - cfg_entry
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Value - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\Julian\GDrive\PGGfMRI\Neuro\Scripts\spm_v2-fullmodel\lvl1_choiceXfeedbackPM_template_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(8, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Units for design - cfg_menu
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Interscan interval - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Value - cfg_entry
    inputs{7, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{8, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Value - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
