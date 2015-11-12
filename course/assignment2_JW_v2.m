% Assignment2.m
% JW 9/25/2015

fmriToolsPath = 'C:\Users\Julian\GDrive\Misc\fMRIcourse\fmriTools';
dataPath = 'C:\Users\Julian\GDrive\Misc\fMRIcourse\CannedData_DS';
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Loading and displaying MRI images %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %---- 1A

p2=load_nii(fullfile(dataPath,'08+Bold_030314',...
    'DS030975+08+Bold_030314.img'));
bold1 = double(p2.img);
bold1Header = p2.hdr;

% p2=load_nii(fullfile(dataPath,'06+run1',...
%     '150728183220.nii'));
% bold1 = double(p2.img);
% bold1Header = p2.hdr;

%% %---- 1B
sgtSlice = 32;
crnSlice = 32;
axlSlice = 17;

figure(1), clf
subplot(3,1,1);
showImage(flipud(squeeze(bold1(sgtSlice,:,:,1))'));
subplot(3,1,2);
showImage(flipud(squeeze(bold1(:,crnSlice,:,1))'));
subplot(3,1,3);
showImage(bold1(:,:,axlSlice,1)');

%% %---- 1C
figure(2)
subplot(2,1,1);
tseries = squeeze(bold1(33,11,10,:)); %same as assignment #1
plot(tseries);
title('Amplitude of Time-Series at Voxel [32,12,10]')
xlabel('TRs')
ylabel('Amplitude')

% need power spectrum (y = power, x = frequency)
% how much of each frequency is present (power)
% time series --> frequency content --> power measure
% P(freq) = | F(freq)|^2
subplot(2,1,2);
Fs = 1;
L = length(tseries);
Y = fft(tseries);
P1 = abs(Y/L) .^ 2;
P = P1(1:L/2+1);
f = Fs*(0:((L-1)/2))/L;
plot(f,P)
% ylim([0 500]);
title('Power Spectrum of Activation at Voxel [32,12,10]')
xlabel('Frequency (Samples/TR)')
ylabel('Power')
hold off



%%
figure(3)
subplot(2,1,1);
tseries_C = tseries-mean(tseries);
plot(tseries_C);
title('Amplitude of Time-Series at Mean Centered Voxel [32,12,10]')
xlabel('TRs')
ylabel('Amplitude')

subplot(2,1,2);

Fs = 1; %TRs per sample
L = length(tseries_C );
Y = fft(tseries_C );
P1 = abs(Y/L) .^ 2;
P = P1(1:L/2+1);
f = Fs*(0:((L-1)/2))/L;
plot(f,P)
%ylim([0 500]);
title('Power Spectrum of Activation after Mean Centering Voxel [32,12,10]')
xlabel('Frequency (Samples/TR)')
ylabel('Power')
hold off

% Before mean-centering, the DC component (baseline) is interpreted as
% a dominant low frequency signal. Because mean-centering is essentially
% a high-pass filter, this low frequency is eliminated, allowing us to 
% observe the true task-related signal. 

%% %---- 2
[m,v] = tseriesMeanVar(tseries)
    
%% %---- 3
X=size(bold1,1);
Y=size(bold1,2);
z=round(size(bold1,3)/2);

m=zeros(X,Y);
v=zeros(X,Y);

for x=1:X;
   for y=1:Y;
       [m(x,y),v(x,y)]=tseriesMeanVar(bold1(x,y,z,:));
   end
end

figure(4)
subplot(2,1,1);
showImage(m) %display mean
subplot(2,1,2);
showImage(v) %display variance

% L = length(tseries);
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(tseries_C,NFFT)/L;
% P = abs(Y) .^ 2;
% %F = 1/N*[1:N/2-1];
% plot(f,2*P(1:NFFT/2+1));
% ylim([0 2000]);
