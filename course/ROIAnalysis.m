function [ roiBeta ] = ROIAnalysis( roiFile,boldFile )
%ROIAnalysis Summary of this function goes here
% create function that returns estimated response amplitude averaged across
% all voxels of ROI. Also plots mean time-series and best fit. 

% dataPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun';
% boldFile=fullfile(dataPath,'151005132409.nii');
% Load the fMRI data:
% p2=load_nii(boldFile);
p2=load_untouch_nii(boldFile);
epi = double(p2.img);
epiHeader = p2.hdr;
epi=epi(:,:,:,6:65); %remove first 10 timepoints

% Load the mask:
% roiPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun\151005132409++.feat\stats';
% roiFile=fullfile(roiPath,'RHemiROI.nii');
% roiFile=fullfile(roiPath,'LHemiROI.nii');
% p2=load_nii(roiFile);
p2=load_untouch_nii(roiFile);
roi = double(p2.img);
roiHeader = p2.hdr;

roiSize = length(find(roi)); %number of voxels in ROI
numFrames = size(epi,4); %length of timeseries
TR=2;
numSecs=numFrames*TR;

% Adjust baselines
tSeries = zeros(numFrames,roiSize);
[x y z] = ind2sub(size(roi),find(roi));
for voxel = 1:roiSize
    tSeries(:,voxel) = squeeze(epi(x(voxel),y(voxel),z(voxel),:));
end
percentTseries = zeros(size(tSeries));
for voxel = 1:roiSize
    baseline = mean(tSeries(:,voxel));
    percentTseries(:,voxel) = 100 * (tSeries(:,voxel)/baseline - 1);
end

% % Plot the mean percent time series.
% plot(mean(percentTseries,2));
% ylabel('fMRI response (% change in image intensity');
% xlabel('Frame');
% title('Mean across voxels in the ROI');

% Plot the time-series of best fit:
% Need: (1) design matrix, (2) parameter estimates, (3) HIRF
% Choose some values for these parameters:
tau = 1.5;
delta = 1.2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

t = [1:numSecs]; %65 TRs total (130 seconds)
blockDuration = 10; %5 TRs (10 seconds)
stimRActivity = mod(ceil(t/blockDuration),2); %on and off for 5 TRs
% stimLActivity = abs(stimRActivity-1); %inverse of right stimulus
% stimLActivity(1:5) = 0; %remove first 10 seconds
% baseline = 100; % might want to come back to this...


% subplot(2,1,2)
% plot(fmriResponse);
% title('fMRI Response to Block Alternation in Neural Activity')
% ylabel('fMRI response (% change in image intensity)')
% xlabel('Time (sec)')

% stimRSignal = baseline + conv(stimRActivity,HIRF);
% stimRSignal = stimRSignal(1:length(stimRActivity));
% stimLSignal = baseline + conv(stimLActivity,HIRF);
% stimLSignal = stimLSignal(1:length(stimLSignal));

% Column 1 and 2: model of activity.
modelStimRActivity = conv(stimRActivity,HIRF);
% modelStimLActivity = conv(stimLActivity,HIRF);
modelStimRActivity = modelStimRActivity(1:length(stimRActivity));
% modelStimLActivity = modelStimLActivity(1:length(stimLActivity));

% % Plot it
% figure(1); clf;
% subplot(2,1,1)
% plot(stimRActivity)
% ylim([0,1.1])
% title('Block Alternation in Neural Activity')
% ylabel('Relative neural activity')
% xlabel('Time (sec)')
% subplot(2,1,2)
% plot(modelStimRActivity);
% title('fMRI Response to Block Alternation in Neural Activity')
% ylabel('fMRI response (% change in image intensity)')
% xlabel('Time (sec)')

% Column 3: linear drift.
modelDrift = [1:numSecs];

% Column 4: constant, baseline image intensity.
modelConstant = ones(1,numSecs);

% Build the design matrix by putting the 4 columns together:
% model = [modelStimRActivity(:) modelStimLActivity(:) modelDrift(:) modelConstant(:)];
model = [modelStimRActivity(:) modelDrift(:) modelConstant(:)];

% Look at the model
model;
model = model(2:TR:numSecs,:) ;%downSample

% Now estimate b (the beta weights).
x=size(epi,1);
y= size(epi,2);
z= size(epi,3);
nVoxels =x*y*z;
data=reshape(epi,nVoxels,numFrames);
b = zeros(3,nVoxels);
% b = zeros(4,nVoxels);
modelInv = pinv(model);
b = modelInv * data';

% mean(b(1,:));
roiData = reshape(roi,nVoxels,1);
roiBeta = b(1,:)'.*roiData;

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(roiData)
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(roiBeta)
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% sum(roiData(:,:,:))
% roiData=data.*repmat(roiData,1,60);

roiBeta = sum(roiBeta)/roiSize;
roiPredActivity = roiBeta.*modelStimRActivity;
roiPredActivity=downsample(roiPredActivity,2);

% figure(2); clf; hold on;
% plot(mean(percentTseries,2));
% plot(roiPredActivity-mean(roiPredActivity),'r')
% ylabel('fMRI response (% change in image intensity');
% xlabel('Frame');
% title('Mean across voxels in the ROI'); hold off;

% roiBeta = b(2,:)'.*roiData;
% roiBeta = sum(roiBeta)/roiSize;
% 
% roiPredActivity = roiBeta.*modelStimLActivity;
% roiPredActivity=downsample(roiPredActivity,2);

hold on;
plot(mean(percentTseries,2),'--b');
plot(roiPredActivity-mean(roiPredActivity),'-.r')
ylabel('fMRI response (% change in image intensity');
xlabel('Frame');
title('Mean across voxels in the ROI'); hold off;

end

