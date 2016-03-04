% eeg_ICA2ERP.m
% Matlab script for ERP(all "ICA-pruned" datasets) :
%   (1)ERP- BINSLISTER
%   (2)ERP- Epoching
%   (3)ERP- Computing and saving ERP

clear all % clear all objects in Workspace %*turn on/off when necessary
close all % delete all unhidden figures %*turn on/off when necessary
clc       % clear Command Window %*turn on/off when necessary
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %*turn on/off when necessary

Path_n_Name='eeg_Path_n_Name'; %Path and Name definition script *in the same folder*
open([pwd, filesep, Path_n_Name,'.m']);
run(Path_n_Name);

%% Bins+Epoch+ERP

cd(pDset_ICA_pruned);

fNames = dir( fullfile(pwd,'*pruned.set') );
fNames_list={fNames.name};

fNames=listdlg('PromptString','Select File :','SelectionMode','mutiple','ListString',fNames_list);
fNames=fNames_list(fNames);

for f=1:length(fNames)
    
    fName=fNames{f};
    Ss=fName(1:3);
    EEG = pop_loadset('filename',fName,'filepath',pwd);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    n=1;
    
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+1,'setname',strcat(Ss,'Clean_ICA_elist'),'gui','off'); 
     
    EEG  = pop_binlister( EEG , 'BDF', fBin, 'ExportEL', strcat(pEvent,'elist_erp_',Ss,'_bin_ICA.txt'), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+2,'setname',strcat(Ss,'Clean_ICA_elist_bins'),'savenew',strcat(pDset_ICA_bin,Ss,'Clean_ICA_elist_bins'),'gui','off');
    EEG = pop_epochbin( EEG , [epoch_pre  epoch_post],  'pre');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+3,'setname',strcat(Ss,'Clean_ICA_elist_bins_be'),'savenew',strcat(pDset_ICA_epoch,Ss,'Clean_ICA_elist_bins_be'),'gui','off'); 
    EEG = eeg_checkset( EEG );
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', strcat(Ss,'_ERP_ICA'), 'filename', strcat(Ss,'_ERP_ICA.erp'), 'filepath', pERPset_ICA, 'Warning', 'on');
        
    ALLEEG = pop_delset( ALLEEG, [1:n+3] );
    eeglab redraw;
    erplab redraw;
    
    clear n
        
end

msgbox('Done.');

cd(pStart);