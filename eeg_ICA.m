% eeg_ICA.m
% Matlab script for EEG running ICA (all "Clean" datasets) :

clear all % clear all objects in Workspace
close all % delete all unhidden figures
clc       % clear Command Window
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

Path_n_Name='eeg_Path_n_Name'; %Path and Name definition script *in the same folder*
open([pwd, filesep, Path_n_Name,'.m']);
run(Path_n_Name);

%% Run ICA
cd(pDset_cln);

fNames = dir( fullfile(pwd,'*.set') );
fNames={fNames.name};

for f=1:length(fNames)
    
    fName=fNames{f};
    Ss=fName(1:3);
    EEG = pop_loadset('filename',fName,'filepath',pwd);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',3,'interupt','on');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat(Ss,'Clean_ICA'),'gui','off');
    EEG = pop_saveset( EEG, 'filename',strcat(Ss,'Clean_ICA.set'),'filepath',pDset_ICA);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    eeglab redraw;
    erplab redraw;
    
end

msgbox('Done.');


cd(pStart);

