%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
global subj
dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/'; %iMac
% dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/'; %PC

matlabbatch{1}.spm.stats.fmri_spec.dir = {[dataDir 's' num2str(subj) '/results/']};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 32;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;


designR1Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r1.csv'];
designR2Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r2.csv'];
designR3Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r3.csv'];
designR4Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r4.csv'];


% header: Give.Onset	G.NumGivP   Keep.Onset	K.NumGivP 	Norm
dsgnR1 = csvread(designR1Filename,1,0);
dsgnR2 = csvread(designR2Filename,1,0);
dsgnR3 = csvread(designR3Filename,1,0);
dsgnR4 = csvread(designR4Filename,1,0);

r1scanfile = dir([dataDir 's' num2str(subj) '/func/run1/unwarped/dvs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1) = 1:219;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r1Scans=[repmat([dataDir 's' num2str(subj) '/func/run1/unwarped/' r1scanfile(1).name],219,1) commas volnums];
r1Scans=cellstr(r1Scans);

r2scanfile = dir([dataDir 's' num2str(subj) '/func/run2/unwarped/dvs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1) = 1:219;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r2Scans=[repmat([dataDir 's' num2str(subj) '/func/run2/unwarped/' r2scanfile(1).name],219,1) commas volnums];
r2Scans=cellstr(r2Scans);

r3scanfile = dir([dataDir 's' num2str(subj) '/func/run3/unwarped/dvs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1) = 1:219;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r3Scans=[repmat([dataDir 's' num2str(subj) '/func/run3/unwarped/' r3scanfile(1).name],219,1) commas volnums];
r3Scans=cellstr(r3Scans);

r4scanfile = dir([dataDir 's' num2str(subj) '/func/run4/unwarped/dvs*.nii']);
commas=repmat(',',219,1);
clear volnums
volnums(1:219,1) = 1:219;
volnums=num2str(volnums,'%-d ');   % The '%-d' is necessary to left-algin
r4Scans=[repmat([dataDir 's' num2str(subj) '/func/run4/unwarped/' r4scanfile(1).name],219,1) commas volnums];
r4Scans=cellstr(r4Scans);

giveOnsetsR1=dsgnR1((dsgnR1(:,1)~=-99),1);
keepOnsetsR1=dsgnR1((dsgnR1(:,3)~=-99),3);
giveOnsetsR2=dsgnR2((dsgnR2(:,1)~=-99),1);
keepOnsetsR2=dsgnR2((dsgnR2(:,3)~=-99),3);
giveOnsetsR3=dsgnR3((dsgnR3(:,1)~=-99),1);
keepOnsetsR3=dsgnR3((dsgnR3(:,3)~=-99),3);
giveOnsetsR4=dsgnR4((dsgnR4(:,1)~=-99),1);
keepOnsetsR4=dsgnR4((dsgnR4(:,3)~=-99),3);

%% Trying to deal w/ problem subjects..
% r(1) = isempty(giveOnsetsR1) | isempty(keepOnsetsR1);
% r(2) = isempty(giveOnsetsR2) | isempty(keepOnsetsR2);
% r(3) = isempty(giveOnsetsR3) | isempty(keepOnsetsR3);
% r(4) = isempty(giveOnsetsR4) | isempty(keepOnsetsR4);
% 
% a = [];
% b= 1;
% 
% if (r1+r2+r3+r4)==4 %extreme case (no valid runs)
%     
% end
% 
% for i=1:4
%     if r(i)==0
%         giveOnsetsR1 = giveOnsetsR2;
%         keepOnsetsR1 = keepOnsetsR2;
%     end
% end
% 
% if r(1)==0
%     if r(2)==0
%         if r(3)==0
%             if r(4)==0
%             else
%                 giveOnsetsR1 = giveOnsetsR4;
%                 keepOnsetsR1 = keepOnsetsR4;
%             end
%         else
%             giveOnsetsR1 = giveOnsetsR3;
%             keepOnsetsR1 = keepOnsetsR3;
%             giveOnsetsR2 = giveOnsetsR4;
%             keepOnsetsR2 = keepOnsetsR4;
%         end 
%     else
%         giveOnsetsR1 = giveOnsetsR2;
%         keepOnsetsR1 = keepOnsetsR2;
%     end
% end
% 
% for i = 1:4
%     if r(i)==0
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = r1Scans;                                                    
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Give';
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = giveOnsetsR1;
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = repmat(4,[size(giveOnsetsR1),1]);
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
% 
% 
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Keep';
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = keepOnsetsR1;
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = repmat(4,[size(keepOnsetsR1),1]);
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
% 
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
%     matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
% end


%%
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = r1Scans;                                                    
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Give';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = giveOnsetsR1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = repmat(4,[size(giveOnsetsR1),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Keep';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = keepOnsetsR1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = repmat(4,[size(keepOnsetsR1),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
%%
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = r2Scans;                                                    
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Give';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = giveOnsetsR2;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = repmat(4,[size(giveOnsetsR2),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'Keep';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = keepOnsetsR2;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = repmat(4,[size(keepOnsetsR2),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;%%
  
  %%
  matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = r3Scans;                                                    
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = 'Give';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = giveOnsetsR3;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = repmat(4,[size(giveOnsetsR3),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = 'Keep';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = keepOnsetsR3;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = repmat(4,[size(keepOnsetsR3),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;%%

  %%
matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = r4Scans;                                                    
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).name = 'Give';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = giveOnsetsR4;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).duration = repmat(4,[size(giveOnsetsR4),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = 'Keep';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = keepOnsetsR4;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = repmat(4,[size(keepOnsetsR4),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).tmod = 0;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;%%
  
 %%


matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Give > Keep';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'bothsc';
matlabbatch{3}.spm.stats.con.delete = 0;

  
