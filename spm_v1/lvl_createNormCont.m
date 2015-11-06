%-----------------------------------------------------------------------
% Job saved on 15-Sep-2015 15:10:04 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
% Purpose: include as many subjects as possible. Only Vet vs. Nonvet Stim.
% No Donation in model. 
%-----------------------------------------------------------------------
% matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/Julian/GDrive/PGGfMRI/Neuro/Level2Results/G_vs_K'};
%%
%exclude: subjects 2, 5, 9, 10, 11, 27, 36, 40, 42
rRunData = csvread('/Users/Julian/GDrive/PGGfMRI/behav/PGG_F_normContrast.csv',1,0);

% 0 = skip; pos = Pro; neg = Anti; 

subs = [1:47]; %4
clear d
for s=1:length(subs)
    
%     s=6; s=47
    f=[];
    a=[];
    b=0;
    clear proCon;
    clear antiCon;
    clear conCode;

    
%     d{s}=['/Users/Julian/GDrive/PGGfMRI/Neuro/Data/s',num2str(subs(s)),'/results']; %testing
    d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/05mask'];
    a=dir(d{s});
    
    for i=1:length(a)
        if strfind(a(i).name,'con_0')==1
            b=b+1;
            f{b}=a(i).name;
        end
    end
    
    runCodes=rRunData(s,2:5)';
    antiCodes=[];
    proCodes=[];
    if sum(runCodes==[0; 0; 0; 0;])==1; %neglect subjects w/ no variant runs
    else
        runIdx = find(runCodes); %indices of acceptable runs
        for i=1:(b-1) % con 1 thru max-1
            conCode(i) = runCodes(runIdx(i)); %run code for contrast (index)
            if conCode(i)>0
                proCodes=[proCodes,conCode(i)]; %vector of prosocial run codes
            elseif conCode(i)<0
                antiCodes=[antiCodes,conCode(i)]; %vector antisocial run codes
            end
        end
        
        %now that Anti/Pro have been mapped, assign contrasts accordingly
        if length(proCodes)==0 | length(antiCodes)==0 % skip subjs w/ invariant choices in norm
        elseif length(proCodes)+length(antiCodes)==4 %all 4 blocks are there
            proCon{1}=[d{s},'/',f{find(conCode==proCodes(1))}]; %file index that matches first prosocial 
            proCon{2}=[d{s},'/',f{find(conCode==proCodes(2))}];
            antiCon{1}=[d{s},'/',f{find(conCode==antiCodes(1))}];
            antiCon{2}=[d{s},'/',f{find(conCode==antiCodes(2))}];
            
            % average two Anti runs, average two Pro runs, then subtract
            spm_imcalc([proCon{1};proCon{2};antiCon{1};antiCon{2}],[d{s},'/con_PROvANTI.nii'],'((i1+i2)/2)-((i3+i4)/2)',{0,0,0,16});
        elseif length(proCodes)==1 & length(antiCodes)==1 %1 of each block
            proCon{1}=[d{s},'/',f{find(conCode==proCodes(1))}]; %file index that matches first prosocial 
            antiCon{1}=[d{s},'/',f{find(conCode==antiCodes(1))}];
            spm_imcalc([proCon{1};antiCon{1}],[d{s},'/con_PROvANTI.nii'],'i1-i2',{0,0,0,16}); %subtract anti from pro
        elseif sum(conCode)>0 % two Pro, one Anti
            proCon{1}=[d{s},'/',f{find(conCode==proCodes(1))}]; %file index that matches first prosocial 
            proCon{2}=[d{s},'/',f{find(conCode==proCodes(2))}];
            antiCon{1}=[d{s},'/',f{find(conCode==antiCodes(1))}];
            
            % average two Anti runs, then subtract from Pro
            spm_imcalc([proCon{1};proCon{2};antiCon{2}],[d{s},'/con_PROvANTI.nii'],'(i1-((i2+i3)/2)',{0,0,0,16});  
        elseif sum(conCode<0) % two Anti, one Pro
            proCon{1}=[d{s},'/',f{find(conCode==proCodes(1))}]; %file index that matches first prosocial 
            antiCon{1}=[d{s},'/',f{find(conCode==antiCodes(1))}];
            antiCon{2}=[d{s},'/',f{find(conCode==antiCodes(2))}];
            
            % average two Pro runs, then subtract Anti run
            spm_imcalc([proCon{1};antiCon{1};antiCon{2}],[d{s},'/con_PROvANTI.nii'],'((i1+i2)/2)-i3',{0,0,0,16});             
        end
    end
end
    
% change 4 to 16 bit integer
% pinfo is much smaller
    c{s}=['/Users/Julian/GDrive/PGGfMRI/Neuro/Data/s',num2str(subs(s)),'/results/05mask/',f{b}];
%     strfind(a(:).name,'spm')
end



% matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
%                                                            '/Users/Julian/GDrive/PGGfMRI_preproc/s1/con_\con_0002.nii,1'
%                                                           '/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(i),' 1/con_\con_0002.nii,1'
%                                                           
%                                                           };
%%
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

% 'C:\Users\Julian\GDrive\Homeless2014\s1\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s3\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s4\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s5\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s6\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s7\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s8\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s9\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s10\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s11\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s12\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s13\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s14\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s15\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s16\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s17\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s18\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s19\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s20\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s21\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s22\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s23\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s24\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s25\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s26\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s27\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s28\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s29\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s30\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s31\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s32\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s33\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s34\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s36\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s37\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s38\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s39\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s40\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s42\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s43\results_presOnly\con_0002.nii,1'
% 'C:\Users\Julian\GDrive\Homeless2014\s44\results_presOnly\con_0002.nii,1'