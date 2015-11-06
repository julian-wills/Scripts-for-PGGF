% List of open inputs

clc
clear all
close all
% subs = 1;
% subs = [3:47];
% subs= [6 7 8 13 14 15 16 17 18 22 25 26 28 30 32 34 35 37 38 39 43 44];
subs= [30 32 34 35 37 38 39 43 44];

%subs = [1 3 5:9 12 14:16 18:29 31:32 34 36:40 42:44]; %1 and 3 run  %excluded due to participants eye sight: 2, 35, 41 and non-variability: 4, 10, 11 13,17, 30, 33, 35
spm_jobman('initcfg');
global subj 

for i=1:length(subs)
    subj=subs(i);
    disp('------------------------------------------');
    disp(['Started level 1 analysis of Subject ' num2str(subj)]);
    nrun = 1; % enter the number of runs here
    %jobfile = {'/Users/shararehn/Documents/Homeless2014/batchFiles/level1_batch_job.m'};
    jobfile = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts/level1Analysis_job.m'};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
%     for crun = 1:nrun
%     end
    spm('defaults', 'FMRI');
    spm_jobman('serial', jobs, '', inputs{:});
    disp(['Completed level 1 analysis of Subject ' num2str(subj)]);
    disp('------------------------------------------');

    
end
% 
% nrun = X; % enter the number of runs here
% jobfile = {'/Users/shararehn/Documents/Homeless2014/batchFiles/level1_batch_job.m'};
% jobs = repmat(jobfile, 1, nrun);
% inputs = cell(0, nrun);
% for crun = 1:nrun
% end
% spm('defaults', 'FMRI');
% spm_jobman('serial', jobs, '', inputs{:});
% 
