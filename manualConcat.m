%% Preconvolving SPM Design Files
%TO DO:
%- round decimals to .1
%- create columns
%- Why does SPM filter give 6 columns (not 4)? 


subj=1;

global subj
% dataDir = '/Users/Julian/GDrive/PGGfMRI_preproc/'; %iMac
dataDir = 'C:/Users/Julian/GDrive/PGGfMRI/Neuro/Data/'; %PC

designR1Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r1.csv'];
designR2Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r2.csv'];
designR3Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r3.csv'];
designR4Filename = [dataDir 's' num2str(subj) '/behav/choice_prevFeedback/s' num2str(subj) '_r4.csv'];


% header: Give.Onset	G.NumGivP   Keep.Onset	K.NumGivP 	Norm
dsgnR1 = csvread(designR1Filename,1,0);
dsgnR2 = csvread(designR2Filename,1,0);
dsgnR3 = csvread(designR3Filename,1,0);
dsgnR4 = csvread(designR4Filename,1,0);

if 

% Round down:

round(dsgnR1,1); %etc...

% to do:

rRunData = csvread('/Users/Julian/GDrive/PGGfMRI/behav/PGG_F_normContrast.csv',1,0);

subs = [1:47]; %4
clear d

designMat=[1 1 0 0 0 1 1 0 0 0 0 0 1 1 0 0]    % Trial length = 4s, TR = 2
TR=2;
modelActivity=conv(designMat, spm_hrf(TR));
modelActivity=modelActivity(1:length(designMat)); 
% This last line is necessary b/c convolution creates a regressor 
% that continues in time past the number of scans; this chops it back to size

% If you need to upsample and downsample, Ed Vessel recommends multiplying the final curve by the sampling amount so it sums to 1, which SPM naturally makes it do. 
% E.g. if you sample every .1 second, then downsample to 1 second (every 10th sample), multiply your vector by 10. 
% 	Creating high pass filter matrix per run: 

numTRs=219;    
o=ones(1,numTRs);
z=zeros(1,numTRs);
d=1:219;
o1=1:219;
o2 = o1+numTRs;
o3 = o2+numTRs;
o4 = o3+numTRs;
run1drift=[d z z z];
run2drift=[z d z z];
run3drift=[z z d z];
run4drift=[z z z d];
run1mean=[o z z z];
run2mean=[z o z z];
run3mean=[z z o z];
run4meand=[z z z o];
% Create high-pass filter through SPM's discrete cosine transform basis set
K.RT=2; % TR = 2s
K.row=1:219; % Bring back true number of TRs--previously 1 was subtracted for 0 indexing
K.HParam=128; % 128s 
nK=spm_filter(K); % Creates basis set 
hpfilter_run=nK.X0; 
% Concatenate to make filters for each run
zhp=zeros(219,4);
hpfilter_r1=[hpfilter_run; zhp; zhp; zhp];
hpfilter_r2=[zhp; hpfilter_run; zhp; zhp];
hpfilter_r3=[zhp; zhp; hpfilter_run; zhp];
hpfilter_r4=[zhp; zhp; zhp; hpfilter_run];
hpfilter_all=[hpfilter_r1 hpfilter_r2 hpfilter_r3 hpfilter_r4];


for s=1:length(subs)
    
    
    zz