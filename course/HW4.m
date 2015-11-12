% fmriTutorialPart4.m
% JAW 10/18/2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Homework 4 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Question 2 
% create function that returns estimated response amplitude averaged across
% all voxels of ROI. Also plots mean time-series and best fit. 

dataPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun';
boldFile=fullfile(dataPath,'151005132409.nii');
roiPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun\151005132409++.feat\stats';
roiFile=fullfile(roiPath,'RHemiROI.nii');
% roiFile2=fullfile(roiPath,'LHemiROI.nii');

roiBetaR = ROIAnalysis(roiFile,boldFile)

  [files, number] = findfiles('/where','*.txt');
  
fs=([]);
fs = reshape(fs,6,0);
 c=cell(6,1);
c{1}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\04+Experimentalrun';
c{2}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\05+Experimentalrun';
c{3}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\06+Experimentalrun';
c{4}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\07+high';
c{5}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\08+low';
c{6}='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\10+high';

for i=1:6
   file=strcat(c{i},'\','*.nii');
   niifile=dir(file);
   boldFile = strcat(c{i},'\',niifile.name);
   roiBetaR(i) = ROIAnalysis(roiFile,boldFile);
%    roiBetaL(i) = ROIAnalysis(roiFile2,boldFile);
end

meanBetas(1)=mean(roiBetaR(1:2:5));
meanBetas(2)=mean(roiBetaR(2:2:6));
seBetas(1)=std(roiBetaR(1:2:5))/ sqrt(length(roiBetaR(1:2:5)));
seBetas(2)=std(roiBetaR(2:2:6))/ sqrt(length(roiBetaR(2:2:6)));

% Right ROI, Left Hemifield
figure(3); hold on
errorbar(meanBetas(1:2),seBetas)
ax = gca;
ax.XTick = [1 2];
ax.XTickLabel = {'Low','High'};
title('Parameter Estimates of High and Low Contrast Stimuli in Right Visual Cortex ROI')
ylabel('Response Amplitude (% signal change)')
xlabel('Contrast Intensity')
hold off;

% Left ROI, Left Hemifield
meanBetas(1)=mean(roiBetaL(1:2:5));
meanBetas(2)=mean(roiBetaL(2:2:6));
seBetas(1)=std(roiBetaL(1:2:5))/ sqrt(length(roiBetaL(1:2:5)));
seBetas(2)=std(roiBetaL(2:2:6))/ sqrt(length(roiBetaL(2:2:6)));

figure(4); hold on
errorbar(meanBetas(1:2),seBetas)
plot([1 2],meanBetas(1:2)-seBetas(1:2),meanBetas(1:2)+seBetas(1:2))
ax = gca;
ax.XTick = [1 2];
ax.XTickLabel = {'Low','High'};
title('Parameter Estimates of High and Low Contrast Stimuli in Left Visual Cortex ROI')
ylabel('Response Amplitude (% signal change)')
xlabel('Contrast Intensity')
hold off;

%% Question 3: SPM Analysis
% create function that returns estimated response amplitude averaged across
% all voxels of ROI. Also plots mean time-series and best fit. 

dataPath='C:\Users\Julian\GDrive\Misc\fMRIcourse\HW4\BlockDesignExp\03+Experimentalrun';
boldFile=fullfile(dataPath,'151005132409.nii');
% tau = 2;
% delta = 2;
X = mod(ceil(t/blockDuration),2);

[ betaMap, sdMap, tMap, pMap ] = SPManalysis(X,1.8,.8,boldFile);

tMapSwap = permute(tMap,[2 1 3]) ;
tMapSwapFlip=flip(tMapSwap,2);
o = make_nii(tMapSwapFlip,[3,3,3],[33,39,17]); %origin -- 
save_nii(o,'tMapSwapFlip.nii');

pMapSwap = permute(pMap,[2 1 3]) ;
pMapSwapFlip=flip(pMapSwap,2);
o = make_nii(1-pMapSwapFlip,[3,3,3],[33,39,17]); %origin -- 
save_nii(o,'pMapSwapFlip.nii');
% 
% [num idx] = max(tMap(:));
% [I_row, I_col,I_z] = ind2sub(size(tMap),idx)
