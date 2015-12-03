% List of open inputs

clc
clear all
close all
% subs = 1;
% subs = [3:47];
% subs= [6 7 8 13 14 15 16 17 18 22 25 26 28 30 32 34 35 37 38 39 43 44];
% subs = [11 12 19 20 21 23 24 29 31 33 41 45 46 47];

subs = [1 3:4 6:8 11:26 28:35 37:39 41 43:47]; %invariant subs

subs = [1 4 6:8 11:18 20:26 28:35 37:39 41 43:47]; %full model subs
subs = [3 19]; %leftovers

% subs = [20:26 28:35 37:39 41 43:47];
% subs = [28:35 37:39 41 43:47]; 
% subs=1;
% subs = 23; %test subject
spm_jobman('initcfg');
global subj 

for i=1:length(subs)
    subj=subs(i);
    spm_jobman('initcfg');
    disp('------------------------------------------');
    disp(['Started level 1 analysis of Subject ' num2str(subj)]);
    nrun = 1; % enter the number of runs here
    jobfile = {'/Users/julian/GDrive/PGGfMRI/Neuro/Scripts/spm_v2-fullmodel/lvl1_FB_PM_job_v2.m'};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
    spm('defaults', 'FMRI');
    spm_jobman('serial', jobs, '', inputs{:});
    disp(['Completed level 1 analysis of Subject ' num2str(subj)]);
    disp('------------------------------------------');
    
end

