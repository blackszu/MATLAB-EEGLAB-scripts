% eeg_Path_n_Name.m
%Matlab script for setting file paths

%% Paths 
pStart=[pwd, filesep];
pData=[pStart,'All_Data_edf',filesep]; %location of all data.edf files
pEvent=[pStart,'~Event_list',filesep]; %location of all event_list files
pDset_ind=[pStart,'~1.Dataset_EEG_individual',filesep]; %location of individual datasets
pDset_mer=[pStart,'~2.Dataset_EEG_merged',filesep]; %location of merged datasets
pDset_cln=[pStart,'~3.Dataset_Clean',filesep]; %location of cleaned datasets **
pDset_ICA=[pStart,'~4.Dataset_ICA',filesep]; %location of ICA-processed datasets (**NOT YET PRUNED**)
pDset_ICA_pruned=[pStart,'~5.Dataset_ICA_pruned',filesep]; %location of ICA-pruned datasets
pDset_ICA_bin=[pStart,'~6.Dataset_ICA_Bin',filesep]; %location of ICA-pruned datasets with BINLISTER
pDset_ICA_epoch=[pStart,'~7.Dataset_ICA_Epoch',filesep]; %location of ICA-pruned datasets with Epoching
pERPset_ICA=[pStart,'~8.ERPset_ICA',filesep]; %location of ICA-pruned ERP sets
pERPset_no_ICA=[pStart,'~9.ERPset_no_ICA',filesep]; % location of ERP sets with NO filters

%% Files
fChannel=strcat(pStart,'9_channels.ced'); %channel location file
fBin=strcat(pStart,'binlister.txt'); %Binlister file
fLog=strcat(pStart,'eeg_result_log.csv');

chan=1:9; %channels
epoch_pre=-400; %window for epoching in msec
epoch_post=600; %window for epoching in msec

cd(pStart);