% eeg_DataMerge_P2P_ERP.m
% Matlab script for EEG+ERP: (***file pathes are NOT UPDATED!!!)
%   (1)EEG- mergeing(appending) datasets by selecting Ss#
%   (2)ERP- BINSLISTER
%   (3)ERP- Epoching
%   **(4)ERP- Detect artifacts with "Peak to Peak"
%   (5)ERP- Computing and saving ERP


clear all % clear all objects in Workspace
close all % delete all unhidden figures
clc       % clear Command Window
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

Path_n_Name='eeg_Path_n_Name'; %Path and Name definition script *in the same folder*
open([pwd, filesep, Path_n_Name,'.m']);
run(Path_n_Name);

fTemp=csvread(fLog);
Ss_list=fTemp(1:length(fTemp));
Ss_list=unique(Ss_list);
Ss_list=arrayfun(@num2str,Ss_list,'unif',0);

clear fTemp

cd(pDset_ind);
Ss_select=listdlg('PromptString','Select Subject # :','SelectionMode','mutiple','ListString',Ss_list);
Ss_select=Ss_list(Ss_select);

 for m=1:length(Ss_select);
    Ss=Ss_select{m};
    if length(Ss)==1; Ss=strcat('S0',Ss); else Ss=strcat('S',Ss); end
    Dset_list=dir(fullfile(pDset_ind,strcat(Ss,'n*.set')));
    Dset_list={Dset_list.name};
    
    for n=1:length(Dset_list);
        Dset=Dset_list{n};
        EEG = pop_loadset('filename',Dset,'filepath',pDset_ind);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    end
%     n=length(Dset_list);
%     EEG = pop_loadset('filename',{Dset_list},'filepath',pDataset_ind);

    EEG = eeg_checkset( EEG );
    EEG = pop_mergeset( ALLEEG, [1:n], 0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+1,'setname',Ss,'savenew',strcat(pDset_mer,Ss),'gui','off');
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+2,'setname',strcat(Ss,'_elist'),'gui','off'); 
     
    EEG  = pop_binlister( EEG , 'BDF', fBin, 'ExportEL', strcat(pEvent,'elist_erp_',Ss,'_bin.txt'), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+3,'setname',strcat(Ss,'_elist_bins'),'savenew',strcat(Ss,'_elist_bins'),'gui','off');
    EEG = pop_epochbin( EEG , [epoch_pre  epoch_post],  'pre');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+4,'setname',strcat(Ss,'_elist_bins_be'),'savenew',strcat(Ss,'_elist_bins_be'),'gui','off'); 
    EEG  = pop_artmwppth( EEG , 'Channel',  chan, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -398.4 597.7], 'Windowsize',  200, 'Windowstep',  100 );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+5,'setname',strcat(Ss,'_elist_bins_be_ar'),'savenew',strcat(Ss,'_elist_bins_be_ar'),'gui','off'); 
    
    EEG = eeg_checkset( EEG );
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', strcat(Ss,'_ERP'), 'filename', strcat(Ss,'_ERP.erp'), 'filepath', pERPset_ICA, 'Warning', 'on');
    
    ALLEEG = pop_delset( ALLEEG, [1:n+5] );
    eeglab redraw;
    erplab redraw;
        
 end

msgbox('Done.');

cd(pStart);


