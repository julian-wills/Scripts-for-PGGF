%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% ArtRepair & LMGS %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

dataDir = '/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
if strncmpi(matlabroot, 'C:\', 3)==1 %if on windows, change file path
    dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
end


HPCDir = '/scratch/jaw588/Homeless2014/'; %If on HPC, change filepaths
if exist(HPCDir, 'dir')~=0
    disp('HPC recognized');
    dataDir = HPCDir;
    folderName = fullfile('/scratch/jaw588/spm12');
    p = genpath(folderName);
    addpath(p);
end   

if exist(dataDir, 'dir')~=0
    disp('Local machine recognized');
    %addpath(genpath('/scratch/jaw588/spm12'));
end  

subj = 1%[31:39]
%subj = [1 3];
%run = [1 2];

HeadMaskType = 4;
RepairType = 1;
tic;
for i = 1:length(subj)
    %clear Pin;
    clear volnums;
    close all;

    %%%Delete ArtifictMask.nii if it exists. Otherwise ArtRepair won't run
    %%%successfully

    %if exist([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/Arti*.nii'], 'file')==2
    %    delete([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/Arti*.nii']);
    %end   
   
    %if exist([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/Arti*.nii'], 'file')==2
    %    delete([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/Arti*.nii']);
    %end   
    
    %%%%%%%%%%%%%%%%%%
    %%% Setup Runs %%%
    %%%%%%%%%%%%%%%%%%
    alignfile1 = dir([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/rp_a*.txt']);
    Ra1 = [dataDir 's' num2str(subj(i)) '/func/run1/unwarped/' alignfile1.name];
    
    r1scanfile = dir([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/sw*.nii']);
    volnums(1:219,1)=7:225;
    volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
    commas=repmat(',',219,1);
    
    r1Scans=[repmat([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
    Pin{1}=r1Scans;
    
    alignfile2 = dir([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/rp_a*.txt']);
    Ra2 = [dataDir 's' num2str(subj(i)) '/func/run2/unwarped/' alignfile2.name];
    r2scanfile = dir([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/sw*.nii']);
    r2Scans=[repmat([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
    Pin{2}=r2Scans;
    
    %%%%%%%%%%%%%%%%%%%
    %%%  ArtRepair  %%%
    %%%%%%%%%%%%%%%%%%%

    art_global_JW(Pin{1},Ra1,HeadMaskType, RepairType)
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r1'],'jpg');
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r1'],'fig');
    disp(['done with subject ', num2str(subj(i)), ',run 1']);
    
    art_global_JW(Pin{2},Ra2,HeadMaskType, RepairType)
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r2'],'jpg');
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r2'],'fig');
    disp(['done with subject ', num2str(subj(i)), ',run 2']);
    close all;

    %%%%%%%%%%%%%%%%%%%
    %%%     LMGS    %%%
    %%%%%%%%%%%%%%%%%%%
    cspm_lmgs_2010b(Pin,1,'d',1,100);
    saveas(gcf,[dataDir 'LMGS/s' num2str(subj(i)) 'r2'],'jpg');
    saveas(gcf,[dataDir 'LMGS/s' num2str(subj(i)) 'r2'],'fig');
    close(gcf);
    
    saveas(gcf,[dataDir 'LMGS/s' num2str(subj(i)) 'r1'],'jpg');
    saveas(gcf,[dataDir 'LMGS/s' num2str(subj(i)) 'r1'],'fig');
    disp(['done with subject ', num2str(subj(i)), ',run 1 and 2']);
end
toc;