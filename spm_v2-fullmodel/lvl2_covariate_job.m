%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
% matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/ChoiceDur_FB_PM/IncG_G/PrefIncG_G'};
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/newDefault/ChoiceDur_FB_PM/IncG_K_fix/PrefIncG_K'};
% matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/ChoiceDur_FB_PM/G_v_K_fix/Cooperation'};
% matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/wholeMaskL1/choiceDur/Pro_v_Anti/NormSens'};

subs = [1 3:4 6:8 11:26 28:35 37:39 41 43:47]; %full model subs (+2 more; N=39)

for s=1:length(subs)
    f=[];
    a=[];
    b=0;
    d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/feedbackPM_choiceDuration'];
    a=dir(d{s});
    for i=1:length(a)
        if strfind(a(i).name,'con_0008')==1 % 1= G>K;    7=IncG after G;    8=IncG after K 
            b=b+1;
            f{b}=a(i).name;
        end
    end
    c{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/feedbackPM_choiceDuration/',f{b},',1'];
end

%%
% b=0;
% 
% subs = [1:47]; %full model subs (+2 more; N=39)
% subs2=[];
% for s=1:length(subs)
%     f=[];
%     a=[];
%     d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask/choiceDur'];
%     a=dir(d{s});
%     for i=1:length(a)
%         if strfind(a(i).name,'con_PROvANTI')==1
%             b=b+1;
%             c{b}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/wholeMask/choiceDur/',a(i).name];
%             subs2(b)=s;
%         end
%     end
% end
% subs = [1:47]; %full model subs (+2 more; N=39)


%%
dataDir = '/Users/Julian/GDrive/PGGfMRI'; %iMac

%Headers: OfferDiff, DGMean,diffID,ProTOtal,DFPrefPro,G.moreNegIncK,saint
covarFile = [dataDir '/Behav/PGGF_lvl2Covars.csv']; 
covars= csvread(covarFile,1,1);

rows_to_keep = any(ismember(covars(:,1),subs), 2);
% rows_to_keep = any(ismember(covars(:,1),subs2), 2);
rows_to_remove = 1-rows_to_keep;
covars(find(rows_to_remove),:) = [];

%%

matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = c';
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = covars(:,7); %IncG G More Pos
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = covars(:,9); %IncG K More Pos
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = covars(:,8); %Cooperation
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = covars(:,2); %Norm Sens

% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'Preference for Inc G when G';
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'Preference for Inc G when K';
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'Cooperation';
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'Norm Sensitivity';

matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Give Inc G x Preference for Inc G when G';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Keep Inc G x Preference for Inc K when K';
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'G>K x Cooperative';
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Norm Consistent Choice x Norm Sensitivity';

matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Give Inc G x Preference for Inc K when G';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Keep Inc G x Preference for Inc G when K';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'G>K x Selfish';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Norm Consistent Choice x Norm Insensitivity';

matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';

%%
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = c';
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = 12-polID(:,2); %convert to cell
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'Liberalism';
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% 
% matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
% matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Vet>NonVet x Liberalism';
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'NonVet>Vet x Conservatism';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
