% JAW 11/6/2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Homework 5 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Question 2 
% Load the ROIs and the data from the event-related scans into matlab. For each ROI, compute the mean time series, averaged across voxels in the ROI and averaged across repeated trials of each of the two trial types 
% (that is, averaging across all of the event-related scans in the session). Compute also the standard error of the mean (SEM) at each time point.

c=cell(4,1);
c{1}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\09+Experimentalrun';
c{2}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\10+Experimentalrun';
c{3}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\11+Experimentalrun';
c{4}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\12+Experimentalrun';

clear epi;
for i=1:4
   file=strcat(c{i},'\','*.nii');
   niifile=dir(file);
   boldFile{i} = strcat(c{i},'\',niifile.name);
   p2=load_untouch_nii(boldFile{i});
    temp(:,:,:,:) = double(p2.img);
    epi(i,:,:,:,:)=temp(:,:,:,30:464); %remove first 29 TRs
end
clear temp;

 c=cell(4,1);
c{1}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\08+LocalizerRun\151022113342_LSP_toExp+.feat\stats';
c{2}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\10+Experimentalrun';
for i=1:4
   file=strcat(c{i},'\','*.nii');
   niifile=dir(file);
   boldFile{i} = strcat(c{i},'\',niifile.name);
   p2=load_untouch_nii(boldFile{2});
    temp(:,:,:,:) = double(p2.img);
    epi(i,:,:,:,:)=temp(:,:,:,3:464); %remove first 28 TRs
end
clear temp;

numFrames = size(epi,5); %length of timeseries (436)
TR=.75;
numSecs=numFrames*TR;

% Load the mask:
roiPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\08+LocalizerRun\151022113342_LSP_toExp+.feat\stats';
roiFile=fullfile(roiPath,'roi-both-t4.nii');
p2=load_untouch_nii(roiFile);
% roi(1,:,:,:) = double(p2.img);
% roiSize(1) = length(find(roi(1,:,:,:))); %number of voxels in ROI

roi = double(p2.img);
roiSize = length(find(roi)); %number of voxels in ROI

% Adjust baselines
clear tSeries
clear baseline
clear percentTseries
% [x y z] = ind2sub(size(roi(1,:,:,:)),find(roi(1,:,:,:)));
[x y z] = ind2sub(size(roi),find(roi));
for run=1:4
     for trial=1:(numFrames/29)
         trialTRs=1:29;
         trialTRs=trialTRs+(29*(trial-1));
        for voxel = 1:roiSize
            tSeries(run,trial,:,voxel) = squeeze(epi(run,x(voxel),y(voxel),z(voxel),trialTRs));
        end
%         percentTseries(run,trial,:,:) = zeros(size(tSeries(1,1,:,:,trialTRs)));
        for voxel = 1:roiSize
            baseline(run,trial) = mean(tSeries(run,trial,:,voxel));
            percentTseries(run,trial,:,voxel) = 100 * (tSeries(run,trial,:,voxel)/baseline(run,trial) - 1);
        end
     end
end

% run X trial X samples X roi voxels
% SEM across runs, trials, voxels 
a = squeeze(mean(mean(percentTseries(:,:,:,:),4),2)); %per run
b(1,:) = (a(1,:)+a(3,:))/2; %single
b(2,:) = (a(2,:)+a(4,:))/2; %double

clear tt
tt(1,:,:,:)=(percentTseries(1,:,:,:)+percentTseries(3,:,:,:))./2; %single
tt(2,:,:,:)=(percentTseries(2,:,:,:)+percentTseries(4,:,:,:))./2; %double

c(1,:)=squeeze(std(std(tt(1,:,:,:),0,4),0,2))/sqrt(trial*2);
c(2,:)=squeeze(std(std(tt(2,:,:,:),0,4),0,2))/sqrt(trial*2);

figure(3); hold on;
errorbar(b(1,:),c(1,:));
errorbar(b(2,:),c(2,:),'r');
ylabel('fMRI response (% change in image intensity');
xlabel('Frame (TRs)');
title('Trial-Triggered Averages and S.E.M.s for Each Trial Type  (t > 4.0 ROI)');
hold off;

%% -- 2nd ROI
roiPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW5\GL_data\08+LocalizerRun\151022113342_LSP_toExp+.feat\stats';
roiFile=fullfile(roiPath,'roi-both-t55.nii');
p2=load_untouch_nii(roiFile);
roi2 = double(p2.img);
roiSize2 = length(find(roi2)); %number of voxels in ROI


clear tSeries
clear baseline
clear percentTseries
% [x y z] = ind2sub(size(roi(1,:,:,:)),find(roi(1,:,:,:)));
[x y z] = ind2sub(size(roi2),find(roi2));
for run=1:4
     for trial=1:(numFrames/29)
         trialTRs=1:29;
         trialTRs=trialTRs+(29*(trial-1));
        for voxel = 1:roiSize2
            tSeries(run,trial,:,voxel) = squeeze(epi(run,x(voxel),y(voxel),z(voxel),trialTRs));
        end
%         percentTseries(run,trial,:,:) = zeros(size(tSeries(1,1,:,:,trialTRs)));
        for voxel = 1:roiSize2
            baseline(run,trial) = mean(tSeries(run,trial,:,voxel));
            percentTseries(run,trial,:,voxel) = 100 * (tSeries(run,trial,:,voxel)/baseline(run,trial) - 1);
        end
     end
end

% run X trial X samples X roi voxels
% SEM across runs, trials, voxels 
a = squeeze(mean(mean(percentTseries(:,:,:,:),4),2)); %per run
b(1,:) = (a(1,:)+a(3,:))/2; %single
b(2,:) = (a(2,:)+a(4,:))/2; %double

clear tt
tt(1,:,:,:)=(percentTseries(1,:,:,:)+percentTseries(3,:,:,:))./2; %single
tt(2,:,:,:)=(percentTseries(2,:,:,:)+percentTseries(4,:,:,:))./2; %double

c(1,:)=squeeze(std(std(tt(1,:,:,:),0,4),0,2))/sqrt(trial*2);
c(2,:)=squeeze(std(std(tt(2,:,:,:),0,4),0,2))/sqrt(trial*2);

figure(4); hold on;
errorbar(b(1,:),c(1,:));
errorbar(b(2,:),c(2,:),'r');
ylabel('fMRI response (% change in image intensity)');
xlabel('Frame (TRs)');
title('Trial-Triggered Averages and S.E.M.s for Each Trial Type (t > 5.5 ROI)');
hold off;




%% Question 3: Linear Prediction
% create function that returns estimated response amplitude averaged across
% all voxels of ROI. Also plots mean time-series and best fit. 
a = squeeze(mean(mean(percentTseries(:,:,:,:),4),2)); %per run
b(1,:) = (a(1,:)+a(3,:))/2; %single
b(2,:) = (a(2,:)+a(4,:))/2; %double

size(tt)
tt(1,:,:,:)

% d=tt(1,:,1:28,:)+tt(1,:,2:29,:);

d(1,1:29)=b(1,1:29);
d(1,2:29)=b(1,2:29)+b(1,1:28);
% d=b(1,1:28)+b(1,2:29);

d2(1,:,:,:)=tt(1,:,:,:);
d2(1,:,2:29,:)=tt(1,:,2:29,:)+tt(1,:,1:28,:);
a2 = squeeze(mean(mean(d2(:,:,:,:),4),2)); %per tt
a2=a2';

c2(1,:)=squeeze(std(std(d2(1,:,:,:),0,4),0,2))/sqrt(trial*2);
 
% c2(1,:)=squeeze(std(std(tt(1,:,:,:),0,4),0,2))/sqrt(trial*2);
% c2(1,:)=squeeze(std(std(tt(1,:,:,:),0,4),0,2))/sqrt(trial*2);

figure(5); hold on;
% errorbar(b(1,:),c(1,:),'b');
errorbar(b(2,:),c(2,:),'b');
errorbar(a2(1,:),c2(1,:),'r--');
ylabel('fMRI response (% change in image intensity');
xlabel('Frame (TRs)');
title('Trial-Triggered Averages and S.E.M. for Double Pulse and Predicted');
hold off;

figure(6); hold on;
errorbar(b(1,:),c(1,:),'b');
% errorbar(b(2,:),c(2,:),'r');
% errorbar(a2(1,:),c2(1,:),'r--');
ylabel('fMRI response (% change in image intensity)');
xlabel('Frame (TRs)');
title('Trial-Triggered Average and S.E.M. for Single Pulse');
hold off;



b(1,:) = (a(1,:)+a(3,:))/2; %single

figure(5); hold on;
plot(b(1,:));
plot(d(1,:),'b--'); 
plot(b(2,:),'r');hold off;

hold off;

%% Question 4: Inferential Statistics via Bootstrapping
% grab random subsample of each trial type
% visualize distributions of parameter estimates
% how different is double flash PE from temporal summation PE? 
% how well does double flash PE correlate with temporal summation PE?

% simulate 1000 times
% randomly draw 1000 timeseries of different voxel, trial, and/or run
% grab all voxels for randomly sampled run

percentTseries( %run; trial; TR; voxel; 

singleRuns = [1 3];
doubleRuns = [2 4];

clear bsTseriesSingle
clear bsTseriesDouble
clear bsTseriesPred 

%         bsTseriesDouble(:,i) = squeeze(mean(percentTseries(doubleRuns(randi(2,1)),randi(15,1),:,:),4));

for k = 1:50
    clear  b
    clear nBSD
    clear tStat
    clear pValue
    clear  nullB
    clear  nModelPredictions
    clear residuals
    clear modelPredictions
    clear bSD
    clear nResiduals
    clear nullData
    for j = 1:1000
        clear bsTseriesSingle
        clear bsTseriesDouble
        clear bsTseriesPred 
        clear bsTseriesNull 
        for i = 1:trial*2 %resample w/ replacement 30 times 
            bsTseriesPred(:,i) = squeeze(mean(percentTseries(singleRuns(randi(2,1)),randi(15,1),:,:),4)); %bootstrap timeSeries
            bsTseriesDouble(:,i) = squeeze(mean(percentTseries(doubleRuns(randi(2,1)),randi(15,1),:,:),4));
            bsTseriesPred(2:29,i)=bsTseriesPred(2:29,i) + bsTseriesPred(1:28,i);
            bsTseriesNull(:,i) = squeeze(mean(percentTseries(randi(4,1),randi(15,1),:,:),4));
        end
        model = mean(bsTseriesPred(:,:),2);
        data = mean(bsTseriesDouble(:,:),2);
        modelInv = pinv(model); %1000 draws of 29 TRs
        b(j) = modelInv * data;
        modelPredictions(:,j)  = model * b(j);
        residuals(:,j)  = (data - modelPredictions(:,j));
        bSD(j) = std(residuals(:,j));
        tStat(j)=b(j)/bSD(j);
        pValue(j) = 1-tcdf(tStat(j),28);
        iteration=[num2str(k),'  ',num2str(j)]
        nullData = mean(bsTseriesNull(:,:),2);    
        nullB(j) = modelInv * nullData;
        nModelPredictions(:,j)  = model * nullB(j);
        nResiduals(:,j)  = (data -  nModelPredictions(:,j));
        nBSD(j) = std( nResiduals(:,j));
    end
    diffDist = b(1,1:1000)-nullB(1,1:1000);
    pFinal(k) = sum(diffDist<0)/1000;
end

% estimated how well data fits null (summation) and variance

figure(6); hist(b(1,1:1000));
title('Bootstrapped Parameter Estimates of Double Pulse Model Fit');

figure(6); hist(b(1,1:1000));
title('Bootstrapped Parameter Estimates of Double Pulse Model Fit');
figure(7); hist(bSD(1,1:1000));
title('Bootrapped SD Estimates of Residuals');

figure(8); hist(b(1,1:1000)-nullB(1,1:1000));
title('Difference of Bootrapped Parameter Estimates based on Null and Actual Data');

% figure; hist(pValue(1,1:1000))
% figure; hist(nullB(1,1:1000));
% figure; hist(nBSD(1,1:1000));    

figure(9); hist(pFinal(1,1:50)); %final histogram of p values
title('Distribution of p-Values from 50 Simulations');

% ylabel('fMRI response (% change in image intensity');
% xlabel('Frame (TRs)');

% diffDist = b(1,1:1000)-nullB(1,1:1000);
% pFinal = sum(diffDist<0)/1000


