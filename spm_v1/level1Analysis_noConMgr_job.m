%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%  JAW: this script only includes analyzable sessions (i.e. runs where subject's
%  choices are not constant Keep/Give) 

global subj
dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/'; %iMac
% dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/'; %PC

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
keepOnsetsR1=dsgnR1((dsgnR1(:,4)~=-99),4);
giveOnsetsR2=dsgnR2((dsgnR2(:,1)~=-99),1);
keepOnsetsR2=dsgnR2((dsgnR2(:,4)~=-99),4);
giveOnsetsR3=dsgnR3((dsgnR3(:,1)~=-99),1);
keepOnsetsR3=dsgnR3((dsgnR3(:,4)~=-99),4);
giveOnsetsR4=dsgnR4((dsgnR4(:,1)~=-99),1);
keepOnsetsR4=dsgnR4((dsgnR4(:,4)~=-99),4);

% Trying to deal w/ problem subjects..
r(1) = isempty(giveOnsetsR1) | isempty(keepOnsetsR1); %returns 1 if at least 1 invariant run
r(2) = isempty(giveOnsetsR2) | isempty(keepOnsetsR2);
r(3) = isempty(giveOnsetsR3) | isempty(keepOnsetsR3);
r(4) = isempty(giveOnsetsR4) | isempty(keepOnsetsR4);

scans{1}=r1Scans;
scans{2}=r2Scans;
scans{3}=r3Scans;
scans{4}=r4Scans;

give{1}=giveOnsetsR1;
keep{1}=keepOnsetsR1;
give{2}=giveOnsetsR2;
keep{2}=keepOnsetsR2;
give{3}=giveOnsetsR3;
keep{3}=keepOnsetsR3;
give{4}=giveOnsetsR4;
keep{4}=keepOnsetsR4;

% j=1;
% j=int16.empty(4,0)

matlabbatch{1}.spm.stats.fmri_spec.dir = {[dataDir 's' num2str(subj) '/results/05mask/']};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 32;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;


j=[];

if sum(r)<4
    for i=1:4
        if i>length(j)
            j(i)=i;
        end
        if r(i)==1
            j(i+1) = j(i);
        else
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).scans = scans{i};                                                    
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(1).name = 'Give';
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(1).onset = give{i};
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(1).duration = repmat(4,[size(give{i}),1]);
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(1).tmod = 0;

            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(2).name = 'Keep';
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(2).onset = keep{i};
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(2).duration = repmat(4,[size(keep{i}),1]);
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).cond(2).tmod = 0;

            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).multi = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).regress = struct('name', {}, 'val', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).multi_reg = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess(j(i)).hpf = 128;
        end
    end

%exclude: subjects 2, 5, 9, 10, 11, 27, 36, 40, 42


    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.5; %change from 0,8 so OFC/amygdala comes through
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Give > Keep';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'bothsc';
    matlabbatch{3}.spm.stats.con.delete = 1;

end
