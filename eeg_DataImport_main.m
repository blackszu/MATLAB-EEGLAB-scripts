% eeg_DataImport_main.m
% Matlab main script for EEG- importing individual data(.edf)
% check sample rate, should be 256

%fName=dir(fullfile(pwd,'*.edf'));
%fName=fName.name;
%fName=strrep(fName,'.edf','');
Ss=strcat('S',fName(3:4));
Sn=strcat('n',fName(length(fName)-4));
fName=strcat(Ss,Sn);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',fName,'gui','off'); 

%import channel
EEG=pop_chanedit(EEG, 'load',{fChannel 'filetype' 'autodetect'});
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

%import event list
EEG = eeg_checkset( EEG );
fEvent=strcat(pEvent,'elist_',fName,'.txt');
EEG = pop_importevent( EEG, 'event',fEvent,'fields',{'latency' 'type'},'skipline',1,...
    'timeunit',1,'append', 'no');
event_no=length(EEG.urevent);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

%save dataset
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',strcat(fName,'.set'),'filepath',pDset_ind);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

Log=[str2double(fName(2:3)),str2double(fName(length(fName))),event_no,EEG.pnts,EEG.srate,EEG.nbchan];
dlmwrite(fLog,Log,'-append');




