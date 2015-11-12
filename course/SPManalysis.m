function [ betaMap, sdMap, tMap, pMap ] = SPManalysis( X,tau,delta,boldFile )
%SPManalysis Computes SPM analysis on fMRI data
%   Write a function to do the analysis that is outlined in fmriTutorialPart2, for each voxel in a data set, that is general 
% enough to be used with any design matrix. Load in your data, create the appropriate design matrix, and use your 
% function to do the analysis. The input to your function will be a design matrix, hirf (or hirf parameters), and a 4D 
% array (x,y,z,t). The output will be a bunch of 3D (x,y,z) arrays corresponding to the parameter estimates and the
% t- and/or p-values.

% X = unconvolved design matrix of stimuli  (function will add mean and
% drift) columns. 

% for testing: design/boldFile from ROIAnalysis. 
% tau = 2;
% delta = 2;
% dataPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun';
% boldFile=fullfile(dataPath,'151005132409.nii');

% stimLActivity = abs(stimRActivity-1); %inverse of right stimulus
% stimLActivity(1:5) = 0; %remove first 10 seconds
% modelStimLActivity = conv(stimLActivity,HIRF);
% modelStimLActivity = modelStimLActivity(1:length(stimLActivity));
% X = mod(ceil(t/blockDuration),2); %on and off for 5 TRs
% X = [modelStimRActivity(:) modelStimLActivity(:)] %left and right

% modelDrift = [1:numSecs];
% modelConstant = ones(1,numSecs);
% model = [modelStimRActivity(:) modelDrift(:) modelConstant(:)];


% create HIRF based on parameters
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

p2=load_untouch_nii(boldFile);
epi = double(p2.img);
% epiHeader = p2.hdr;
epi=epi(:,:,:,6:65); %remove first 10 timepoints

numFrames = size(epi,4); %length of timeseries
TR=2;
numSecs=numFrames*TR;
% t = [1:numSecs]; %65 TRs total (130 seconds)
% blockDuration = 10; %5 TRs (10 seconds)
% stimRActivity = mod(ceil(t/blockDuration),2); %on and off for 5 TRs
% modelStimRActivity = conv(stimRActivity,HIRF);
% modelStimRActivity = modelStimRActivity(1:length(stimRActivity));
% X = mod(ceil(t/blockDuration),2);

% Column 1: model of activity.
modelStimActivity = conv(X,HIRF);
modelStimActivity = modelStimActivity(1:length(X));

% Column 2: linear drift.
modelDrift = [1:numSecs];

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,numSecs);

% Build the design matrix by putting the 4 columns together:
model = [modelStimActivity(:) modelDrift(:) modelConstant(:)];
model = model(2:TR:numSecs,:) ;%downSample

x=size(epi,1);
y= size(epi,2);
z= size(epi,3);
nVoxels =x*y*z;
data=reshape(epi,nVoxels,numFrames);
b = zeros(3,nVoxels);
modelInv = pinv(model);
b = modelInv * data';
%%
modelPredictions = model * b;
residuals = (data' - modelPredictions); %transpose to align matrices

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

% Next we will transform the residualSD to compute the SD of the parameter
% estimates. We really care only about the 1st parameter that represents
% the amplitude of neural activity so that's the only one we'll compute. To
% pick this one (while ignoring the others) we define a 'contrast' vector:
c = [1 0 0]';

% Compute the parameter SD for each voxel:
bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end

% Now we have everything we need and we can do a t-test for each
% voxel. The T statistic is the ratio of the parameter estimate to the
% estimated SD. The p value is computed from the T statistic using the
% cumulative distribution function.
tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% output wil be an 8D matrix (X, Y, Z, beta, t, p, sd, EV); a map for each parameter
% estimated in design. 

betaMap=reshape(b(1,:),x,y,z);
sdMap=reshape(bSD,x,y,z);
tMap=reshape(tStat,x,y,z);
pMap=reshape(pValue,x,y,z);


end

