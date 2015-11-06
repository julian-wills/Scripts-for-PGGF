# PGG fMRI study, setup folders for fMRI analysis
# Oct 30, 2015
# Julian Wills

require(magrittr) || {install.packages("magrittr"); require(magrittr)} #needed for pipe (%>%) operator

# detect which computer: Lab iMac or PC Laptop?
if (grepl("^C:/",getwd())) {
  userDir <- "C:/Users/Julian/GDrive" #PC
} else {
  userDir <- "/Users/julian/GDrive" #Mac
}

dataDir=paste0(userDir,"/PGGfMRI_preproc") #set target directory for data

# loop through all subjects, creating folder structure for each
for (s in 1:47) {
  subjDir=file.path(dataDir, paste0("s",s))
  dir.create(subjDir, showWarnings = FALSE)
  dir.create(file.path(subjDir, "behav"), showWarnings = FALSE)
  dir.create(file.path(subjDir, "anat"), showWarnings = FALSE)
  dir.create(file.path(subjDir, "anat/unwarped"), showWarnings = FALSE)
  dir.create(file.path(subjDir, "func"), showWarnings = FALSE)
  for (r in 1:4) {
    dir.create(file.path(subjDir, paste0("func/run",r)), showWarnings = FALSE)
    dir.create(file.path(subjDir, paste0("func/run",r,"/unwarped")), showWarnings = FALSE)
  }
  dir.create(file.path(subjDir, "results"), showWarnings = FALSE)
}

# Transfer relevant raw files to target directory
rawDir=paste0(userDir,"/PGGfMRI_backup") #set to raw data directory 
subjDirs=dir(rawDir,full.names=T) #list all folders in this directory
subjDirs=subjDirs[grepl("2015",subjDirs)] #remove folders that don't contain subject data

# loop through each subject, grab warped/unwarped .nii for anatomical and each functional run, copy to target directory
for (d in subjDirs) {
  s = unlist(strsplit(d,"[.]"))[4]  %>% sub("s","",.)
  targetDir=paste0(userDir,"/PGGfMRI_preproc/s",s)
  anatDir = paste0(dir(d,full.names = T)[grep("mprage",dir(d,full.names = T))],"/unwarped")
  anatFile = list.files(anatDir,full.names=F)
  file.copy(from = file.path(anatDir,anatFile), to = paste0(targetDir,"/anat/unwarped/"))
  for (r in 1:4) {
    run=paste0("run",r) #creates string for current run (e.g. "run1)
    
    #copy warped NIFTI: select .nii files > remove excess NIFTIs (e.g. _bo,_rho)
    funcDir = paste0(dir(d,full.names = T)[grep(run,dir(d,full.names = T))],"")
    funcFileT = list.files(funcDir,full.names=F)[grepl(".nii",list.files(funcDir,full.names=F))]
    funcFile = funcFileT[!grepl("bo|rho|rs",funcFileT)]
    file.copy(from = file.path(funcDir,funcFile), to = paste0(targetDir,"/func/",run,"/"))
    
    #copy unwarped NIFTI: select .nii files > remove excess NIFTIs (e.g. _bo,_rho)
    funcDir = paste0(dir(d,full.names = T)[grep(run,dir(d,full.names = T))],"/unwarped")
    funcFile = list.files(funcDir,full.names=F)[!grepl("bo|rho|rs",list.files(funcDir,full.names=F))]
    file.copy(from = file.path(funcDir,funcFile), to = paste0(targetDir,"/func/",run,"/unwarped/"))
  }
  print(paste("finished copying files for subject",s))
}
