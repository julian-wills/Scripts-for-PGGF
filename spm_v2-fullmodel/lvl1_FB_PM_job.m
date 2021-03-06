%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%  JAW: this script only includes analyzable sessions (i.e. runs where subject's
%  choices are not constant Keep/Give) 

% Bug: feedback onsets are 4 seconds ahead of where they ought to be. 

global subj
dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/'; %iMac
% dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/'; %PC

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

% scanfiles=[r1Scans; r2Scans ;r3Scans; r4Scans];

%%
designR1Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_PM.csv'];
dsgnFile = csvread(designR1Filename,1,0);

%  G.Block	G.NumGiv	G.On	G.ITI.On	G.ISI.On	G.ITI.Dur	G.ISI.Dur	K.Block	K.NumGiv	K.On	K.ITI.On	K.ISI.On	K.ITI.Dur	K.ISI.Dur	M.Block	M.NumGiv	M.On	M.ITI.On	M.ISI.On	M.ITI.Dur	M.ISI.Dur
gOn=dsgnFile((dsgnFile(:,2)~=-99),2);
gFBOn=dsgnFile((dsgnFile(:,2)~=-99),3)-4; %workaround until bug identified
gFBPM=dsgnFile((dsgnFile(:,2)~=-99),4);
gITI=dsgnFile((dsgnFile(:,2)~=-99),5);
gISI=dsgnFile((dsgnFile(:,2)~=-99),6);
gITIdur=dsgnFile((dsgnFile(:,2)~=-99),7);
gISIdur=dsgnFile((dsgnFile(:,2)~=-99),8);

kOn=dsgnFile((dsgnFile(:,10)~=-99),10);
kFBOn=dsgnFile((dsgnFile(:,10)~=-99),11)-4;
kFBPM=dsgnFile((dsgnFile(:,10)~=-99),12);
kITI=dsgnFile((dsgnFile(:,10)~=-99),13);
kISI=dsgnFile((dsgnFile(:,10)~=-99),14);
kITIdur=dsgnFile((dsgnFile(:,10)~=-99),15);
kISIdur=dsgnFile((dsgnFile(:,10)~=-99),16);

mOn=[];
if size(dsgnFile,2)>16
    mOn=dsgnFile((dsgnFile(:,18)~=-99),18);
    mFBOn=dsgnFile((dsgnFile(:,18)~=-99),19)-4;
    mITI=dsgnFile((dsgnFile(:,18)~=-99),21);
    mISI=dsgnFile((dsgnFile(:,18)~=-99),22);
    mITIdur=dsgnFile((dsgnFile(:,18)~=-99),23);
    mISIdur=dsgnFile((dsgnFile(:,18)~=-99),24);
end

scans{1}=r1Scans;
scans{2}=r2Scans;
scans{3}=r3Scans;
scans{4}=r4Scans;

scanfiles=[scans{1}; scans{2} ;scans{3}; scans{4}];

matlabbatch{1}.spm.stats.fmri_spec.dir = {[dataDir 's' num2str(subj) '/results/feedbackPM/']};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 32;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = scanfiles;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Give';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = gOn;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = repmat(4,[size(gOn),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Give Feedback';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = gFBOn;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = repmat(7,[size(gFBOn),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;            
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod.name = 'Number of Givers';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod.param = gFBPM;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod.poly = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'Keep';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = kOn;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = repmat(4,[size(kOn),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Keep Feedback';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = kFBOn;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = repmat(7,[size(kFBOn),1]);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;            
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod.name = 'Number of Givers';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod.param = kFBPM;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod.poly = 1;      

% new trial
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'Cue';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [gITI; kITI;];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = [gITIdur; kITIdur;];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;                                

if isempty(mOn)==0 
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).name = 'Missed';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = mOn;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).duration = repmat(4,[size(mOn),1]);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 0;     
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).name = 'Miss Feedback';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).onset = mFBOn;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).duration = repmat(7,[size(mFBOn),1]);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).tmod = 0;             

    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'Cue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [gITI; kITI; mISI];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = [gITIdur; kITIdur; mISIdur;];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;                        
end



r = length(scanfiles)/4;

% mean regressors
o=zeros(4,length(scanfiles)); 
o(1,(0*r+1):(r*1))=ones(size(o(1,1:r)));
o(2,(1*r+1):(r*2))=ones(size(o(1,1:r)));
o(3,(2*r+1):(r*3))=ones(size(o(1,1:r)));
o(4,(3*r+1):(r*4))=ones(size(o(1,1:r)));

% drift regressors
d=zeros(4,length(scanfiles)); 
d(1,(0*r+1):(r*1))=1:r;
d(2,(1*r+1):(r*2))=1:r;
d(3,(2*r+1):(r*3))=1:r;
d(4,(3*r+1):(r*4))=1:r;   

matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'Run 1 Mean';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = o(1,:);
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Run 1 Drift';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = d(1,:); 
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Run 2 Mean';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = o(2,:);
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).name = 'Run 2 Drift';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).val = d(2,:);  
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Run 3 Mean';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = o(3,:);
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).name = 'Run 3 Drift';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).val = d(3,:);  
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Run 4 Mean';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = o(4,:);
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).name = 'Run 4 Drift';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).val = d(4,:);      
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;


% z=zeros(1,155); 
% d=1:155;
%exclude: subjects 2, 5, 9, 10, 11, 27, 36, 40, 42


matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
% matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.5; %change from 0,8 so OFC/amygdala comes through
% matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf; %change from 0,8 so OFC/amygdala comes through
matlabbatch{1}.spm.stats.fmri_spec.mask = {'/Users/julian/Downloads/mask20_no_eyeballs_roi/mask20_no_eyeballs.nii,1'};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% add contrasts: PM (1 1 Num of Givers),
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Give > Keep';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Feedback after G > K';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 -1 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Increasing # of Givers after G > K';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Increasing # of Givers';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 1 0 0 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Cue/Fixation';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Decision';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [1 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
matlabbatch{3}.spm.stats.con.delete = 1;
