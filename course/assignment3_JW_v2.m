%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   Question 1   %%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);
HIRF=gaussmf(t,[1.5 6]);

t = [1:120];
blockDuration = 6;
neuralActivity = mod(ceil(t/blockDuration),2)*1;
fmriSignal = baseline + conv(neuralActivity,HIRF);
fmriSignal = fmriSignal(1:length(neuralActivity));

% Make a time series of "images", each with 2000 voxels, half of which will be
% activated and the other half not activated:
nTime = length(fmriSignal);
% Fill nonactive voxels with baseline image intensity
nonactiveVoxels = baseline * ones(nTime,1000);
% Fill active voxels, each with a copy of fmriSignal
activeVoxels = repmat(fmriSignal(:),[1,1000]);

% put the two together, one above the other
data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

% Add noise and drift
noiseSD = .1;
driftRate = 0.01;
% add noise
noise = noiseSD * randn(size(data));
data = data + noise;
% add drift
for t=1:nTime
    data(t,:) = data(t,:) + t*driftRate;
end

tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

% Column 1: model of activity. Here again we will compute our model for the
% fMRI signal, computed by convolving our model for the underlying neural
% activity with our model for the hemodynamic impulse response function:
modelActivity = conv(neuralActivity,HIRF);
modelActivity = modelActivity(1:length(neuralActivity));
% This is the same as what was done to produce the simulated data above,
% except that we didn't bother adding the baseline image intensity nor the
% drift (as above) because we will deal with both of those things in the
% other two columns of X.

% Column 2: linear drift.
modelDrift = [1:nTime];

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,nTime);

% Build the design matrix by putting the 3 columns together:
model = [modelActivity(:) modelDrift(:) modelConstant(:)];
% Look at the model
model;

% Now estimate b (the beta weights). The equation is:
%    y = X b
% where we want to solve for b. So we compute:
%    b = pinv(X) * y
% where the 'pinv' function in matlab computes the pseudo-inverse of a
% matrix.
nVoxels = size(data,2);
b = zeros(3,nVoxels);
modelInv = pinv(model);
for voxel=1:nVoxels
    b(:,voxel) = modelInv * data(:,voxel);
end

% Note that you can also do this without the loop:
%   b = modelInv * data;

% Plot the parameter estimates
% figure(1); clf;
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(b(2,:))
% title('Estimates of Drift')
% ylabel('Drift rate (delta image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(b(3,:))
% title('Estimates of Baseline Intensity')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

 %Putting error bars on the parameter estimates

% bint provides a confidence interval for the parameter estimates b. If we
% set alpha=0.05 then this will be a 95% confidence interval.

% Let's try it (but be patient because this function is a bit slow):
b = zeros(3,nVoxels);
bmin = zeros(3,nVoxels);
bmax = zeros(3,nVoxels);
for voxel=1:nVoxels
    [btmp,bint,r,rint,stats] = regress(data(:,voxel),model,0.05);
    b(:,voxel) = btmp;
    bmin(:,voxel) = bint(:,1);
    bmax(:,voxel) = bint(:,2);
end

% Plot the parameter estimates (from every 20th voxel) with error bars
% subVox = [1:20:nVoxels];
% 
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-5,10]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-0.3,1.3]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% errorbar(subVox,b(2,subVox),b(2,subVox)-bmin(2,subVox),bmax(2,subVox)-b(2,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Drift rate (image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% errorbar(subVox,b(3,subVox),b(3,subVox)-bmin(3,subVox),bmax(3,subVox)-b(3,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')


figure(3); clf;
subplot(2,1,1)
hist(b(1,1:1000))
title('Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
% xlim([-4 4])
% xlim([-1 2])
xlim([-1 8])
subplot(2,1,2)
hist(b(1,1001:2000))
title('Non Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
% xlim([-4 4])
% xlim([-1 2])
xlim([-1 8])

modelPredictions = model * b;
residuals = (data - modelPredictions);
% Plot the SD of the residuals for each voxel:
figure(3); clf;
plot(std(residuals))
title('Residuals of the model fit')
ylabel('SD of residuals (image intensity units)')
xlabel('Position (voxel #)')

residualsZscore = residuals(:)/noiseSD;
% Then plot a histogram superimposed with the normal pdf:
nSamples = length(residualsZscore);
step = 0.1;
x = [-5:step:5];
histResiduals = hist(residualsZscore,x)/(step*nSamples);
normalPDF = normpdf(x,0,1);
figure(3); clf;
bar(x,histResiduals);
hold on;
plot(x,normalPDF,'r');
hold off;
title('Residuals Compared with Normal Distribution')
ylabel('Probability/Frequency')
xlabel('Z score')

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end
figure(3); clf;
plot(bSD)
title('SD of Estimated Neural Activity')
ylabel('SD of neural activity (arb units)')
xlabel('Position (voxel #)')

mean(bSD)
std(b(1,1:1000))
std(b(1,1001:2000))

tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% Plot 'em
figure(3); clf;
subplot(2,1,1)
plot(tStat);
title('T statistic')
ylabel('T value')
xlabel('Position (voxel #)')
subplot(2,1,2)
plot(pValue);
title('P value')
ylabel('P value')
xlabel('Position (voxel #)')

% Count the number of "false alarms" among the pixels that are not
% active. There should be about 50 out of 1000 with pvalues < 0.05 and
% there should be about 10 with pvalues < 0.01.
sum(pValue(1001:2000) < 0.05)
sum(pValue(1001:2000) < 0.01)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   Question 2   %%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = 4;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);
% HIRF=gaussmf(t,[1.5 6]);

t = [1:120];
blockDuration = 6;
amp = 1;
neuralActivity = mod(ceil(t/blockDuration),2)*amp;
fmriSignal = baseline + conv(neuralActivity,HIRF);
fmriSignal = fmriSignal(1:length(neuralActivity));

% Make a time series of "images", each with 2000 voxels, half of which will be
% activated and the other half not activated:
nTime = length(fmriSignal);
% Fill nonactive voxels with baseline image intensity
nonactiveVoxels = baseline * ones(nTime,1000);
% Fill active voxels, each with a copy of fmriSignal
activeVoxels = repmat(fmriSignal(:),[1,1000]);

% put the two together, one above the other
data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

% Add noise and drift
noiseSD = 2;
driftRate = 0.01;
% add noise
noise = noiseSD * randn(size(data));
data = data + noise;
% add drift
for t=1:nTime
    data(t,:) = data(t,:) + t*driftRate;
end

tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

% Column 1: model of activity. Here again we will compute our model for the
% fMRI signal, computed by convolving our model for the underlying neural
% activity with our model for the hemodynamic impulse response function:
modelActivity = conv(neuralActivity,HIRF);
modelActivity = modelActivity(1:length(neuralActivity));
% This is the same as what was done to produce the simulated data above,
% except that we didn't bother adding the baseline image intensity nor the
% drift (as above) because we will deal with both of those things in the
% other two columns of X.

% Column 2: linear drift.
modelDrift = [1:nTime];

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,nTime);

% Build the design matrix by putting the 3 columns together:
model = [modelActivity(:) modelDrift(:) modelConstant(:)];
% Look at the model
model;

% Now estimate b (the beta weights). The equation is:
%    y = X b
% where we want to solve for b. So we compute:
%    b = pinv(X) * y
% where the 'pinv' function in matlab computes the pseudo-inverse of a
% matrix.
nVoxels = size(data,2);
b = zeros(3,nVoxels);
modelInv = pinv(model);
for voxel=1:nVoxels
    b(:,voxel) = modelInv * data(:,voxel);
end

% Note that you can also do this without the loop:
%   b = modelInv * data;

% Plot the parameter estimates
% figure(1); clf;
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(b(2,:))
% title('Estimates of Drift')
% ylabel('Drift rate (delta image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(b(3,:))
% title('Estimates of Baseline Intensity')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

 %Putting error bars on the parameter estimates

% bint provides a confidence interval for the parameter estimates b. If we
% set alpha=0.05 then this will be a 95% confidence interval.

% Let's try it (but be patient because this function is a bit slow):
b = zeros(3,nVoxels);
bmin = zeros(3,nVoxels);
bmax = zeros(3,nVoxels);
for voxel=1:nVoxels
    [btmp,bint,r,rint,stats] = regress(data(:,voxel),model,0.05);
    b(:,voxel) = btmp;
    bmin(:,voxel) = bint(:,1);
    bmax(:,voxel) = bint(:,2);
end

% Plot the parameter estimates (from every 20th voxel) with error bars
% subVox = [1:20:nVoxels];
% 
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-5,10]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-0.3,1.3]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% errorbar(subVox,b(2,subVox),b(2,subVox)-bmin(2,subVox),bmax(2,subVox)-b(2,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Drift rate (image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% errorbar(subVox,b(3,subVox),b(3,subVox)-bmin(3,subVox),bmax(3,subVox)-b(3,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')


figure(2); clf;
subplot(2,1,1)
hist(b(1,1:1000))
title('Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])
subplot(2,1,2)
hist(b(1,1001:2000))
title('Non Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])

modelPredictions = model * b;
residuals = (data - modelPredictions);
% Plot the SD of the residuals for each voxel:
figure(3); clf;
plot(std(residuals))
title('Residuals of the model fit')
ylabel('SD of residuals (image intensity units)')
xlabel('Position (voxel #)')

residualsZscore = residuals(:)/noiseSD;
% Then plot a histogram superimposed with the normal pdf:
nSamples = length(residualsZscore);
step = 0.1;
x = [-5:step:5];
histResiduals = hist(residualsZscore,x)/(step*nSamples);
normalPDF = normpdf(x,0,1);
figure(3); clf;
bar(x,histResiduals);
hold on;
plot(x,normalPDF,'r');
hold off;
title('Residuals Compared with Normal Distribution')
ylabel('Probability/Frequency')
xlabel('Z score')

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end
figure(4); clf;
plot(bSD)
title('SD of Estimated Neural Activity')
ylabel('SD of neural activity (arb units)')
xlabel('Position (voxel #)')

mean(bSD)
std(b(1,1:1000))
std(b(1,1001:2000))

tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% Plot 'em
figure(5); clf;
subplot(2,1,1)
plot(tStat);
title('T statistic')
ylabel('T value')
xlabel('Position (voxel #)')
subplot(2,1,2)
plot(pValue);
title('P value')
ylabel('P value')
xlabel('Position (voxel #)')

% Count the number of "false alarms" among the pixels that are not
% active. There should be about 50 out of 1000 with pvalues < 0.05 and
% there should be about 10 with pvalues < 0.01.
sum(pValue(1001:2000) < 0.05)
sum(pValue(1001:2000) < 0.01)



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   Question 3   %%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);
% HIRF=gaussmf(t,[1.5 6]);

t = [1:120];
blockDuration = 6;
neuralActivity = mod(ceil(t/blockDuration),2)*1;
fmriSignal = baseline + conv(neuralActivity,HIRF);
fmriSignal = fmriSignal(1:length(neuralActivity));

% Make a time series of "images", each with 2000 voxels, half of which will be
% activated and the other half not activated:
nTime = length(fmriSignal);
% Fill nonactive voxels with baseline image intensity
nonactiveVoxels = baseline * ones(nTime,1000);
% Fill active voxels, each with a copy of fmriSignal
activeVoxels = repmat(fmriSignal(:),[1,1000]);

% put the two together, one above the other
data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

% Add noise and drift
noiseSD = .1;
driftRate = 0.01;
% add noise
noise = noiseSD * randn(size(data));
data = data + noise;
% add drift
for t=1:nTime
    data(t,:) = data(t,:) + t*driftRate;
end

tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

% Column 1: model of activity. Here again we will compute our model for the
% fMRI signal, computed by convolving our model for the underlying neural
% activity with our model for the hemodynamic impulse response function:
modelActivity = conv(neuralActivity,HIRF);
modelActivity = modelActivity(1:length(neuralActivity));
% This is the same as what was done to produce the simulated data above,
% except that we didn't bother adding the baseline image intensity nor the
% drift (as above) because we will deal with both of those things in the
% other two columns of X.

% Column 2: linear drift.
modelDrift = [1:nTime];

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,nTime);

% Build the design matrix by putting the 3 columns together:
model = [modelActivity(:) modelDrift(:) modelConstant(:)];
% Look at the model
model;

% Now estimate b (the beta weights). The equation is:
%    y = X b
% where we want to solve for b. So we compute:
%    b = pinv(X) * y
% where the 'pinv' function in matlab computes the pseudo-inverse of a
% matrix.
nVoxels = size(data,2);
b = zeros(3,nVoxels);
modelInv = pinv(model);
for voxel=1:nVoxels
    b(:,voxel) = modelInv * data(:,voxel);
end

% Note that you can also do this without the loop:
%   b = modelInv * data;

% Plot the parameter estimates
% figure(1); clf;
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(b(2,:))
% title('Estimates of Drift')
% ylabel('Drift rate (delta image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(b(3,:))
% title('Estimates of Baseline Intensity')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

 %Putting error bars on the parameter estimates

% bint provides a confidence interval for the parameter estimates b. If we
% set alpha=0.05 then this will be a 95% confidence interval.

% Let's try it (but be patient because this function is a bit slow):
b = zeros(3,nVoxels);
bmin = zeros(3,nVoxels);
bmax = zeros(3,nVoxels);
for voxel=1:nVoxels
    [btmp,bint,r,rint,stats] = regress(data(:,voxel),model,0.05);
    b(:,voxel) = btmp;
    bmin(:,voxel) = bint(:,1);
    bmax(:,voxel) = bint(:,2);
end

% Plot the parameter estimates (from every 20th voxel) with error bars
% subVox = [1:20:nVoxels];
% 
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-5,10]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-0.3,1.3]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% errorbar(subVox,b(2,subVox),b(2,subVox)-bmin(2,subVox),bmax(2,subVox)-b(2,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Drift rate (image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% errorbar(subVox,b(3,subVox),b(3,subVox)-bmin(3,subVox),bmax(3,subVox)-b(3,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')


figure(2); clf;
subplot(2,1,1)
hist(b(1,1:1000))
title('Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])
subplot(2,1,2)
hist(b(1,1001:2000))
title('Non Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])

modelPredictions = model * b;
residuals = (data - modelPredictions);
% Plot the SD of the residuals for each voxel:
figure(3); clf;
plot(std(residuals))
title('Residuals of the model fit')
ylabel('SD of residuals (image intensity units)')
xlabel('Position (voxel #)')

residualsZscore = residuals(:)/noiseSD;
% Then plot a histogram superimposed with the normal pdf:
nSamples = length(residualsZscore);
step = 0.1;
x = [-5:step:5];
histResiduals = hist(residualsZscore,x)/(step*nSamples);
normalPDF = normpdf(x,0,1);
figure(3); clf;
bar(x,histResiduals);
hold on;
plot(x,normalPDF,'r');
hold off;
title('Residuals Compared with Normal Distribution')
ylabel('Probability/Frequency')
xlabel('Z score')

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end
figure(4); clf;
plot(bSD)
title('SD of Estimated Neural Activity')
ylabel('SD of neural activity (arb units)')
xlabel('Position (voxel #)')

mean(bSD)
std(b(1,1:1000))
std(b(1,1001:2000))

tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% Plot 'em
figure(5); clf;
subplot(2,1,1)
plot(tStat);
title('T statistic')
ylabel('T value')
xlabel('Position (voxel #)')
subplot(2,1,2)
plot(pValue);
title('P value')
ylabel('P value')
xlabel('Position (voxel #)')

% Count the number of "false alarms" among the pixels that are not
% active. There should be about 50 out of 1000 with pvalues < 0.05 and
% there should be about 10 with pvalues < 0.01.
sum(pValue(1001:2000) < 0.05)
sum(pValue(1001:2000) < 0.01)




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   Question 4   %%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);
% HIRF=gaussmf(t,[1.5 6]);

t = [1:120];
blockDuration = 6;
neuralActivity = mod(ceil(t/blockDuration),2)*1;
fmriSignal = baseline + conv(neuralActivity,HIRF);
fmriSignal = fmriSignal(1:length(neuralActivity));

% Make a time series of "images", each with 2000 voxels, half of which will be
% activated and the other half not activated:
nTime = length(fmriSignal);
% Fill nonactive voxels with baseline image intensity
nonactiveVoxels = baseline * ones(nTime,1000);
% Fill active voxels, each with a copy of fmriSignal
activeVoxels = repmat(fmriSignal(:),[1,1000]);

% put the two together, one above the other
data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

% Add noise and drift
noiseSD = .1;
driftRate = 0.01;
% add noise
noise = noiseSD * randn(size(data));
data = data + noise;
% add drift
for t=1:nTime
    data(t,:) = data(t,:) + (t^2)*driftRate;
end

tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

% Column 1: model of activity. Here again we will compute our model for the
% fMRI signal, computed by convolving our model for the underlying neural
% activity with our model for the hemodynamic impulse response function:
modelActivity = conv(neuralActivity,HIRF);
modelActivity = modelActivity(1:length(neuralActivity));
% This is the same as what was done to produce the simulated data above,
% except that we didn't bother adding the baseline image intensity nor the
% drift (as above) because we will deal with both of those things in the
% other two columns of X.

% Column 2: linear drift.
modelDrift = [1:nTime];
% modelDrift = modelDrift.^2;

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,nTime);

% Build the design matrix by putting the 3 columns together:
model = [modelActivity(:) modelDrift(:) modelConstant(:)];
% Look at the model
model;

% Now estimate b (the beta weights). The equation is:
%    y = X b
% where we want to solve for b. So we compute:
%    b = pinv(X) * y
% where the 'pinv' function in matlab computes the pseudo-inverse of a
% matrix.
nVoxels = size(data,2);
b = zeros(3,nVoxels);
modelInv = pinv(model);
for voxel=1:nVoxels
    b(:,voxel) = modelInv * data(:,voxel);
end

% Note that you can also do this without the loop:
%   b = modelInv * data;

% Plot the parameter estimates
% figure(1); clf;
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(b(2,:))
% title('Estimates of Drift')
% ylabel('Drift rate (delta image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(b(3,:))
% title('Estimates of Baseline Intensity')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

 %Putting error bars on the parameter estimates

% bint provides a confidence interval for the parameter estimates b. If we
% set alpha=0.05 then this will be a 95% confidence interval.

% Let's try it (but be patient because this function is a bit slow):
b = zeros(3,nVoxels);
bmin = zeros(3,nVoxels);
bmax = zeros(3,nVoxels);
for voxel=1:nVoxels
    [btmp,bint,r,rint,stats] = regress(data(:,voxel),model,0.05);
    b(:,voxel) = btmp;
    bmin(:,voxel) = bint(:,1);
    bmax(:,voxel) = bint(:,2);
end

% Plot the parameter estimates (from every 20th voxel) with error bars
% subVox = [1:20:nVoxels];
% 
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-5,10]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-0.3,1.3]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% errorbar(subVox,b(2,subVox),b(2,subVox)-bmin(2,subVox),bmax(2,subVox)-b(2,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Drift rate (image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% errorbar(subVox,b(3,subVox),b(3,subVox)-bmin(3,subVox),bmax(3,subVox)-b(3,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')


figure(1); clf;
subplot(2,1,1)
hist(b(1,1:1000))
title('Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])
subplot(2,1,2)
hist(b(1,1001:2000))
title('Non Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
xlim([-4 4])
% xlim([-1 2])
% xlim([-1 8])

modelPredictions = model * b;
residuals = (data - modelPredictions);
% Plot the SD of the residuals for each voxel:
figure(2); clf;
plot(std(residuals))
title('Residuals of the model fit')
ylabel('SD of residuals (image intensity units)')
xlabel('Position (voxel #)')

residualsZscore = residuals(:)/noiseSD;
% Then plot a histogram superimposed with the normal pdf:
nSamples = length(residualsZscore);
step = 0.1;
x = [-5:step:5];
histResiduals = hist(residualsZscore,x)/(step*nSamples);
normalPDF = normpdf(x,0,1);
figure(3); clf;
bar(x,histResiduals);
hold on;
plot(x,normalPDF,'r');
hold off;
title('Residuals Compared with Normal Distribution')
ylabel('Probability/Frequency')
xlabel('Z score')

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end
figure(4); clf;
plot(bSD)
title('SD of Estimated Neural Activity')
ylabel('SD of neural activity (arb units)')
xlabel('Position (voxel #)')

mean(bSD)
std(b(1,1:1000))
std(b(1,1001:2000))

tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% Plot 'em
figure(5); clf;
subplot(2,1,1)
plot(tStat);
title('T statistic')
ylabel('T value')
xlabel('Position (voxel #)')
subplot(2,1,2)
plot(pValue);
title('P value')
ylabel('P value')
xlabel('Position (voxel #)')

% Count the number of "false alarms" among the pixels that are not
% active. There should be about 50 out of 1000 with pvalues < 0.05 and
% there should be about 10 with pvalues < 0.01.
sum(pValue(1001:2000) < 0.05)
sum(pValue(1001:2000) < 0.01)



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   Question 5   %%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseline = 100;

% baseline baseline-.001
gradient = repmat([1:-.0001:.90001],120,1);
gradient = repmat([1:-.0005:.50001],120,1);

t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);
% HIRF=gaussmf(t,[1.5 6]);

t = [1:120];
blockDuration = 6;
neuralActivity = mod(ceil(t/blockDuration),2)*1;
fmriSignal = baseline + conv(neuralActivity,HIRF);
fmriSignal = fmriSignal(1:length(neuralActivity));

% Make a time series of "images", each with 2000 voxels, half of which will be
% activated and the other half not activated:
nTime = length(fmriSignal);
% Fill nonactive voxels with baseline image intensity
nonactiveVoxels = baseline * ones(nTime,1000) .* gradient;

% Fill active voxels, each with a copy of fmriSignal
activeVoxels = repmat(fmriSignal(:),[1,1000]) .* gradient;

% put the two together, one above the other
data = [activeVoxels nonactiveVoxels];
% The result is a 2d array: nTimePoints x nVoxels
size(data)

% Add noise and drift
noiseSD = .1;
driftRate = 0.01;
% add noise
noise = noiseSD * randn(size(data));
data = data + noise;
% add drift
for t=1:nTime
    data(t,:) = data(t,:) + (t^1)*driftRate;
end

tau = 2;
delta = 2;
t = [0:1:30];
tshift = max(t-delta,0);
HIRF = (tshift/tau).^2 .* exp(-tshift/tau) / (2*tau);

% Column 1: model of activity. Here again we will compute our model for the
% fMRI signal, computed by convolving our model for the underlying neural
% activity with our model for the hemodynamic impulse response function:
modelActivity = conv(neuralActivity,HIRF);
modelActivity = modelActivity(1:length(neuralActivity));
% This is the same as what was done to produce the simulated data above,
% except that we didn't bother adding the baseline image intensity nor the
% drift (as above) because we will deal with both of those things in the
% other two columns of X.

% Column 2: linear drift.
modelDrift = [1:nTime];
% modelDrift = modelDrift.^2;

% Column 3: constant, baseline image intensity.
modelConstant = ones(1,nTime);

% Build the design matrix by putting the 3 columns together:
model = [modelActivity(:) modelDrift(:) modelConstant(:)];
% Look at the model
model;

% Now estimate b (the beta weights). The equation is:
%    y = X b
% where we want to solve for b. So we compute:
%    b = pinv(X) * y
% where the 'pinv' function in matlab computes the pseudo-inverse of a
% matrix.
nVoxels = size(data,2);
b = zeros(3,nVoxels);
modelInv = pinv(model);
for voxel=1:nVoxels
    b(:,voxel) = modelInv * data(:,voxel);
end

% Note that you can also do this without the loop:
%   b = modelInv * data;

% Plot the parameter estimates
% figure(1); clf;
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% plot(b(1,:))
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% plot(b(2,:))
% title('Estimates of Drift')
% ylabel('Drift rate (delta image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% plot(b(3,:))
% title('Estimates of Baseline Intensity')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

 %Putting error bars on the parameter estimates

% bint provides a confidence interval for the parameter estimates b. If we
% set alpha=0.05 then this will be a 95% confidence interval.

% Let's try it (but be patient because this function is a bit slow):
b = zeros(3,nVoxels);
bmin = zeros(3,nVoxels);
bmax = zeros(3,nVoxels);
for voxel=1:nVoxels
    [btmp,bint,r,rint,stats] = regress(data(:,voxel),model,0.05);
    b(:,voxel) = btmp;
    bmin(:,voxel) = bint(:,1);
    bmax(:,voxel) = bint(:,2);
end

% Plot the parameter estimates (from every 20th voxel) with error bars
% subVox = [1:20:nVoxels];
% 
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-5,10]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')

% figure(2); clf;
% subplot(3,1,1)
% errorbar(subVox,b(1,subVox),b(1,subVox)-bmin(1,subVox),bmax(1,subVox)-b(1,subVox))
% set(gca,'xlim',[-20 2000]);
% set(gca,'ylim',[-0.3,1.3]);
% title('Estimates of Neural Activity')
% ylabel('Amplitude of Neural Activity (arb units)')
% xlabel('Position (voxel #)')
% subplot(3,1,2)
% errorbar(subVox,b(2,subVox),b(2,subVox)-bmin(2,subVox),bmax(2,subVox)-b(2,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Drift rate (image intensity/sec)')
% xlabel('Position (voxel #)')
% subplot(3,1,3)
% errorbar(subVox,b(3,subVox),b(3,subVox)-bmin(3,subVox),bmax(3,subVox)-b(3,subVox))
% set(gca,'xlim',[-20 2000]);
% title('Estimates of Drift')
% ylabel('Mean image intensity (raw image intensity units)')
% xlabel('Position (voxel #)')

figure(1); clf;
subplot(2,1,1)
hist(b(1,1:1000))
title('Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
% xlim([-4 4])
% xlim([-13 -11])
xlim([-1 2])
subplot(2,1,2)
hist(b(1,1001:2000))
title('Non Active Voxels')
ylabel('Number of voxels')
xlabel('Estimated neural activity')
% xlim([-4 4])
% xlim([-13 -11])
xlim([-1 2])

modelPredictions = model * b;
residuals = (data - modelPredictions);
% Plot the SD of the residuals for each voxel:
figure(2); clf;
plot(std(residuals))
title('Residuals of the model fit')
ylabel('SD of residuals (image intensity units)')
xlabel('Position (voxel #)')

residualsZscore = residuals(:)/noiseSD;
% Then plot a histogram superimposed with the normal pdf:
nSamples = length(residualsZscore);
step = 0.1;
x = [-5:step:5];
histResiduals = hist(residualsZscore,x)/(step*nSamples);
normalPDF = normpdf(x,0,1);
figure(3); clf;
bar(x,histResiduals);
hold on;
plot(x,normalPDF,'r');
hold off;
title('Residuals Compared with Normal Distribution')
ylabel('Probability/Frequency')
xlabel('Z score')

residualSD = std(residuals);
residualVar = residualSD.*residualSD;

bSD = zeros(size(residualSD));
for voxel=1:nVoxels
    bSD(voxel) = sqrt(c' * modelInv * modelInv' * c * residualVar(voxel));
end
figure(4); clf;
plot(bSD)
title('SD of Estimated Neural Activity')
ylabel('SD of neural activity (arb units)')
xlabel('Position (voxel #)')

mean(bSD)
std(b(1,1:1000))
std(b(1,1001:2000))

tStat = b(1,:)./bSD;
pValue = 1-tcdf(tStat,117);

% Plot 'em
figure(5); clf;
subplot(2,1,1)
plot(tStat);
title('T statistic')
ylabel('T value')
xlabel('Position (voxel #)')
subplot(2,1,2)
plot(pValue);
title('P value')
ylabel('P value')
xlabel('Position (voxel #)')

% Count the number of "false alarms" among the pixels that are not
% active. There should be about 50 out of 1000 with pvalues < 0.05 and
% there should be about 10 with pvalues < 0.01.
sum(pValue(1001:2000) < 0.05)
sum(pValue(1001:2000) < 0.01)
