# MATLAB-EEGLAB-scripts
Some example scripts for processing EDF format EEG data using MATLAB's EEGLAB 12.0.1.0b (Delorme & Makeig, 2004) and ERPLAB 4.0.2.3 (Lopez-Calderon & Luck, 2014)

##(1) eeg_Path_n_Name.m
- set file paths for stages of processed files
- set channels, bins, and parameters

##(2) eeg_DataImport_main.m
- import individual data(.edf)

##(3) eeg_DataImport_merge_run.m
- run the main script(2) for importing individual data(.edf)
- merge(append) datasets by selecting Ss# (single or multiple)

##(4) eeg_ICA.m
- EEG post-process using independent component analysis(ICA)

##(5) eeg_ICA2ERP.m
- ERP process for ICA-pruned datasets : 
- ERP - BINSLISTER, Epoching, Computing and saving ERP

##(6) eeg_DataMerge_P2P_ERP.m
- merge(append) datasets by selecting Ss# (single or multiple)
- ERP process with post-processing using peak-to-peak amplitude detection(P2PW)
- ERP- BINSLISTER
- ERP- Epoching
- ERP- Detect artifacts with "Peak to Peak"
- ERP- Computing and saving ERP

##(7) eeg_EEG2ERP_no_ICA.m
- ERP process for "merged" datasets, no post processing
- ERP- BINSLISTER
- ERP- Epoching
- ERP- Computing and saving ERP
