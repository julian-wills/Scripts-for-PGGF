

global subj
global deleteLast


dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/';
if strncmpi(matlabroot, 'C:\', 3)==1 %if on windows, change file path
    dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
end

% dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/';
%dataDirSW = '/Users/shararehn/Documents/Homeless2014/';

%subj = [1 3:39];
% subj = [1];
run = [1 2 3 4];

% for i = 1:length(subj)
%     clear Pin;
clear r1scanfile
clear r2scanfile
clear r3scanfile
clear r4scanfile    
clear commas

r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/vs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
Pin{1}=r1Scans;
Pin{run(1)}=r1Scans;

r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/vs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
Pin{2}=r2Scans;
Pin{run(2)}=r2Scans;

r3scanfile = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/vs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r3Scans=[repmat([dataDir 's' num2str(subj) '/func/run3/unwarped/' r3scanfile(1).name],219,1) commas volnums];
Pin{3}=r3Scans;
Pin{run(3)}=r3Scans;

r4scanfile = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/vs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1)=7:225;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r4Scans=[repmat([dataDir 's' num2str(subj) '/func/run4/unwarped/' r4scanfile(1).name],219,1) commas volnums];
Pin{4}=r4Scans;    
Pin{run(4)}=r4Scans;    

cspm_lmgs_2010b(Pin,1,'d',1,100);
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r1'],'jpg');
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r1'],'fig');
close(gcf);
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r2'],'jpg');
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r2'],'fig');
close(gcf);
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r3'],'jpg');
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r3'],'fig');
close(gcf);
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r4'],'jpg');
saveas(gcf,[dataDir 'plots/lmgsOut/s' num2str(subj) 'r4'],'fig');    
disp(['done with subject ', num2str(subj), ',runs 1, 2, 3, and 4']);
close(gcf);

if deleteLast==1
    delete([dataDir 's' num2str(subj) '/func/run1/unwarped/v*.nii']) %delete old files
    delete([dataDir 's' num2str(subj) '/func/run2/unwarped/v*.nii']) 
    delete([dataDir 's' num2str(subj) '/func/run3/unwarped/v*.nii']) 
    delete([dataDir 's' num2str(subj) '/func/run4/unwarped/v*.nii'])   
end
         
% end 

%%
%     r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/vs*.nii']);
%     commas=repmat(',',179,1);
%     clear volnums
%     volnums(1:179,1)=7:185;
%     volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
%     r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],179,1) commas volnums];
%     Pin{1}=r1Scans;
%     
%     r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/vs*.nii']);
%     commas=repmat(',',179,1);
%     clear volnums
%     volnums(1:179,1)=7:185;
%     volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
%     r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],179,1) commas volnums];
%     Pin{2}=r2Scans;
%    
%     cspm_lmgs_2010b(Pin,1,'d',1,100);
%%


% r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/sw*.nii']);
% commas=repmat(',',179,1);
% clear volnums
% volnums(1:179,1)=7:185;
% volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
% r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],179,1) commas volnums];
% %r1Scans=cellstr(r1Scans);
% %Pin{1}=r1Scans;
% %Pin{1}=r1scanfile;
% Pin{run(1)}=r1Scans;
% 
% % r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/sw*.nii']);
% % commas=repmat(',',179,1);
% % clear volnums
% % volnums(1:179,1)=7:185;
% % volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
% % r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],179,1) commas volnums];
% % %r2Scans=cellstr(r2Scans);
% % Pin{run(2)}=r2Scans;
% 
% cspm_lmgs_2010b(Pin,1,'d',1,100);
% %h = gcf;
% %saveas(h,[dataDir 'LMGS/' num2str(subj) '.jpg']);
% saveas(gcf,[dataDir 'LMGS/s' num2str(subj) 'r' num2str(run)],'jpg');

