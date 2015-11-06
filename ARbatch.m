%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% ArtRepair & LMGS %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all

global subj;
global deleteLast;

dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/';
if strncmpi(matlabroot, 'C:\', 3)==1 %if on windows, change file path
    dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
end

%dataDirSW = '/Users/shararehn/Documents/Homeless2014/';

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

%subj = 37%[31:39]
%subj = [1 3];
% subj=3;
run = [1 2 3 4];

HeadMaskType = 4;
RepairType = 1;
tic;
% for i = 1:length(subj)
    %%%Delete ArtifictMask.nii if it exists. Otherwise ArtRepair won't run
    %%%successfully

if exist([dataDir 's' num2str(subj) '/func/run1/unwarped/Arti*.nii'], 'file')==2
   delete([dataDir 's' num2str(subj) '/func/run1/unwarped/Arti*.nii']);
end   

if exist([dataDir 's' num2str(subj) '/func/run2/unwarped/Arti*.nii'], 'file')==2
   delete([dataDir 's' num2str(subj) '/func/run2/unwarped/Arti*.nii']);
end   

%%% Setup Runs %%%
clear Pin;
clear volnums;
close all;

alignfile1 = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/rp_a*.txt']);
Ra1 = [dataDir 's' num2str(subj) '/func/run1/unwarped/' alignfile1.name];
r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/sw*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
Pin{1}=r1Scans;

alignfile2 = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/rp_a*.txt']);
Ra2 = [dataDir 's' num2str(subj) '/func/run2/unwarped/' alignfile2.name];
r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/sw*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
Pin{2}=r2Scans;

alignfile3 = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/rp_a*.txt']);
Ra3 = [dataDir 's' num2str(subj) '/func/run3/unwarped/' alignfile3.name];
r3scanfile = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/sw*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r3Scans=[repmat([dataDir 's' num2str(subj) '/func/run3/unwarped/' r3scanfile(1).name],219,1) commas volnums];
Pin{3}=r3Scans;

alignfile4 = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/rp_a*.txt']);
Ra4 = [dataDir 's' num2str(subj) '/func/run4/unwarped/' alignfile4.name];
r4scanfile = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/sw*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r4Scans=[repmat([dataDir 's' num2str(subj) '/func/run4/unwarped/' r4scanfile(1).name],219,1) commas volnums];
Pin{4}=r4Scans;    

%%%%%%%%%%%%%%%%%%%
%%%  ArtRepair  %%%
%%%%%%%%%%%%%%%%%%%

art_global_JW(Pin{1},Ra1,HeadMaskType, RepairType)
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r1'],'jpg');
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r1'],'fig');
disp(['done with subject ', num2str(subj), ',run 1']);

art_global_JW(Pin{2},Ra2,HeadMaskType, RepairType)
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r2'],'jpg');
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r2'],'fig');
disp(['done with subject ', num2str(subj), ',run 2']);
close all;

art_global_JW(Pin{3},Ra3,HeadMaskType, RepairType)
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r3'],'jpg');
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r3'],'fig');
disp(['done with subject ', num2str(subj), ',run 3']);
close all;

art_global_JW(Pin{4},Ra4,HeadMaskType, RepairType)
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r4'],'jpg');
saveas(gcf,[dataDir 'plots/artRepairOut/s' num2str(subj) 'r4'],'fig');
disp(['done with subject ', num2str(subj), ',run 4']);
close all;    

if deleteLast==1
    delete([dataDir 's' num2str(subj) '/func/run1/unwarped/s*.nii']) %delete old files
    delete([dataDir 's' num2str(subj) '/func/run2/unwarped/s*.nii']) 
    delete([dataDir 's' num2str(subj) '/func/run3/unwarped/s*.nii']) 
    delete([dataDir 's' num2str(subj) '/func/run4/unwarped/s*.nii'])   
end
    
% end
toc;