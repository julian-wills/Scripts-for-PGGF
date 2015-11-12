%%%Created by Oliver Vikbladh. Modified by Julian. 

clear all
tic;
% %defining matrices
cort=[]; %cortical structures from HO atlas
sub=[]; %subcortical structures from HO atlas
patientss=[]; %patients

% %set working directory
%cd '/Users/vanbaveladmin/GDrive/LesionProject/Masks/Collected' %Lab
cd '/Users/Julian/GDrive/LesionProject/Masks/Collected' %Laptop
%cd '/CBI/Users/julian/Documents/LesionWorkshop/FrontalMasks' %Room 204

subs= [1 3:4 6:8 12:26 28:35 37:39 41 43:47];

% %reading in patients
pAll = dir('*.nii');
pN = size(pAll,1);



subs= [1 3:4 6:8 12:26 28:35 37:39 41 43:47];

b=0
for s=1:length(subs)
    f=[];
    a=[];
%     b=0;
    d{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/05mask'];
    a=dir(d{s});
    for i=1:length(a)
        if strfind(a(i).name,'mask')==1
            b=b+1;
%             f{b}=a(i).name;
            c{b}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/05mask/',a(i).name];
        end
    end
%     c{s}=['/Users/Julian/GDrive/PGGfMRI_preproc/s',num2str(subs(s)),'/results/05mask/',f{b},',1'];
%     strfind(a(:).name,'spm')
end

% c=c';
clear masks
for s=1:length(subs);
    p2=load_nii(c{s});
    p3=double(p2.img);
    masks(:,:,:,s)=p3; %Windows friendly
%     masks(:,:,:,s)=niftiread(c{s}); %CBI Nifti tools
end

%patientss(:,:,:,1)=niftiread('P41_MNI-mask.nii');
%patientss(:,:,:,2)=niftiread('P046_MNI-mask.nii');
%patientss(:,:,:,3)=niftiread('P178_MNI.nii');

%patientss=zeros(X,Y,Z,nP);

%cd '/CBI/Users/julian/Documents/LesionWorkshop/LSMscripts'

% %dimensions
X=size(masks,1);
Y=size(masks,2);
Z=size(masks,3);

% %number of patients
n_sub=size(masks,4);

%new mask matrix with ones and zeros (in case there are other values)
% patients=zeros(X,Y,Z,n_pat);

% for w=1:n_sub;
%     patients(:,:,:,p)=arrayfun(@nnz,patientss(:,:,:,p));
% end

%collapse patient dimension to create overlay
mask_overlap = zeros(X,Y,Z);
for s=1:n_sub;
    mask_overlap = mask_overlap + masks(:,:,:,s);
end

cd '/Users/Julian/GDrive/PGGfMRI/Neuro/Scripts' %Laptop

o = make_nii(mask_overlap, [], [26 32 22.5]); %origin
save_nii(o,'overlay_38subs_pggf.nii');



%overlay intersection
masks_union=arrayfun(@nnz,masks);

for w=1:n_sub;
    patients(:,:,:,p)=arrayfun(@nnz,patientss(:,:,:,p));
end

i = make_nii(masks_union, [], [26 32 22.5]); %origin
save_nii(i,'union_38subs_pggf.nii');

% create mask where each value reflects a subject
sMap = make_nii(masks_union, [], [26 32 22.5]); %origin
save_nii(i,'union_38subs_pggf.nii');



%sum(sum(sum(patients_overlap))) 
%max(max(max(patients_overlap)))

%a = patientss(:,:,:,1) - patients(:,:,:,1)
%sum(sum(sum(a)))
%sum(sum(sum(patientss(:,:,:,1))))
%max(max(max(patientss(:,:,:,1)))

%x [-91,90] y [91,-126] z [-72,109]
toc
