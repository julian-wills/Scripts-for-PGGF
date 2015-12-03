% Created by: Julian on Oct 29, 20115
% Purpose: wrapper for preprocessing steps for PGG fMRI study. 
% Slice timing > Realignment > Coregistration > Normalization > Smoothing
% Artifact Repair > Global Linear Detrending 
% Set deleteLast == 1 to delete output of previous step (save space) 


clear all %leave uncommented
close all %leave uncommented
clc
clear classes
% List of open inputs
%tic
global subj 
global deleteLast

% Subject 2 missing run 3 
% subs= [1 3:47]; %31:40
% subs=[1 3:47];
subs=[25:47];

% subs=[2 3 19] %reconstructed and missing from earlier (11/11)
subs=[19 6 12 28 2] %reconstructed and missing from earlier (11/30)

deleteLast = 1;

% if strncmpi(matlabroot, 'C:\', 3)==1 %if on windows, change file path
%         jobfile = {'/Users/julian/GDrive/PGGfMRI/Neuro/Scripts/PreproScript_JW_job.m'};
% end

dataDir = '/Users/julian/GDrive/PGGfMRI_preproc/';

% spm_jobman('initcfg');
for idx=1:length(subs)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    tic;
    subj=subs(idx);
    nrun = 1; %% enter the number of runs here
    jobfile = {'/Users/julian/GDrive/PGGfMRI/Neuro/Scripts/PreproScript_JW_job.m'};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
    for crun = 1:nrun
    end
    spm_jobman('serial', jobs, '', inputs{:});
    t1 = toc;
   
    
    tic;
    disp(['Started Smoothing Subject ' num2str(subj)]);
    smoothing_JW
    disp(['Completed Smoothing Subject ' num2str(subj)]);
    disp('-------------------------------------------');
    t2 = toc;
    
    runs=[1 2 3 4];
        if deleteLast==1
            for r=1:length(runs)
                delete([dataDir 's' num2str(subj) '/func/run' num2str(runs(r)) '/unwarped/a*.nii']) %delete old files
                delete([dataDir 's' num2str(subj) '/func/run' num2str(runs(r)) '/unwarped/ra*.nii']) 
                delete([dataDir 's' num2str(subj) '/func/run' num2str(runs(r)) '/unwarped/wra*.nii']) %deletes too much
%                 delete([dataDir 's' num2str(subj) '/func/run4/unwarped/a*.nii'])     
            end
        end

    
    tic;
    disp(['Started repairing artifacts for Subject ' num2str(subj)]);
    ARbatch
    disp(['Completed repairing artifacts for Subject ' num2str(subj)]);
    disp('-------------------------------------------');
    t3 = toc;
    
    tic;
    disp(['Started detrending Subject ' num2str(subj)]);
    lmgsBatch
    disp(['Completed detrending Subject ' num2str(subj)]);
    disp('-------------------------------------------');
    
    t3 = toc;
%     t4 = t1 + t2 +t3;
%     disp(t4);
   
end
% t5 = t5 + t4;


