clear all
dataDir = '/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';

HPCDir = '/scratch/jaw588/Homeless2014/'; %If on HPC, change filepaths
if exist(HPCDir, 'dir')==2
    dataDir = HPCDir;
    addpath(genpath('/scratch/jaw588/spm12'));
end   

% subj = [29:39]
%subj = [1 3];
%run = [1 2];

HeadMaskType = 4;
RepairType = 1;

global subj;

for i = 1:length(subj)
     clear Pin;
     clear r1scanfile;
     clear r2scanfile;
     clear r3scanfile;
     clear r4scanfile;
    clear volnums
   
    alignfile1 = dir([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/rp_a*.txt']);
    Ra1 = [dataDir 's' num2str(subj(i)) '/func/run1/unwarped/' alignfile1.name];
    r1scanfile = dir([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/sw*.nii']);
    volnums(1:179,1)=7:185;
    volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
    commas=repmat(',',179,1);
    r1Scans=[repmat([dataDir 's' num2str(subj(i)) '/func/run1/unwarped/' r1scanfile(1).name],179,1) commas volnums];
    Pin{1}=r1Scans;
    
    alignfile2 = dir([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/rp_a*.txt']);
    Ra2 = [dataDir 's' num2str(subj(i)) '/func/run2/unwarped/' alignfile2.name];
    r2scanfile = dir([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/sw*.nii']);
    r2Scans=[repmat([dataDir 's' num2str(subj(i)) '/func/run2/unwarped/' r2scanfile(1).name],179,1) commas volnums];
    Pin{2}=r2Scans;
    
    art_global_JW(Pin{1},Ra1,HeadMaskType, RepairType)
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r1'],'jpg');
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r1'],'fig');
    disp(['done with subject ', num2str(subj(i)), ',run 1']);
    
    art_global_JW(Pin{2},Ra2,HeadMaskType, RepairType)
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r2'],'jpg');
    saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r2'],'fig');
    disp(['done with subject ', num2str(subj(i)), ',run 2']);
    

end

    %art_global_JW(Pin,Ra,HeadMaskType, RepairType)
    
    %     cspm_lmgs_2010b(Pin,1,'d',1,100);
    %saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r1'],'jpg');
    %     close(gcf);
    %saveas(gcf,[dataDir 'artOutput/s' num2str(subj(i)) 'r2'],'jpg');
    %     close(gcf);
%art_global_JW(Images,RealignmentFile,HeadMaskType, RepairType)

