%Matlab script for EEG Plot Components (ICA-processed Datasets)

Path_n_Name='eeg_Path_n_Name'; %Path and Name definition script *in the same folder*
open([pwd, filesep, Path_n_Name,'.m']);
run(Path_n_Name);

% close(2:3)  %*turn on/off when necessary

%% for opening a dataset
% ALLEEG = pop_delset( ALLEEG, [1] );
cd(pDset_ICA);
fName=uigetfile('*_ICA.set');
EEG = pop_loadset('filename',fName,'filepath',pwd);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%% for plotting an already-opened dataset:
Dset=str2double(inputdlg('Dataset no. :'));
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',Dset,'study',0); 
EEG = eeg_checkset( EEG );

%% Plot Components
%plot components heatmap
pop_topoplot(EEG,0, [1:9] ,EEG.setname,[3 3] ,0,'electrodes','on');
EEG = eeg_checkset( EEG );

%plot "reject components by map"
pop_selectcomps(EEG, [1:9] );
EEG = eeg_checkset( EEG );

%plot properties of all components (shows 9 figures)
pop_prop( EEG, 0, [1:9], NaN, {'freqrange' [2 50] });
EEG = eeg_checkset( EEG );

%Plot spectra of specified data channels or components. Show scalp maps of power at specified frequencies
figure; pop_spectopo(EEG, 0, [0      1101973.9233], 'EEG' , 'freq', [10], 'plotchan', 0, 'percent', 20, 'icacomps', [1:9], 'nicamaps', 5, 'freqrange',[2 25],'electrodes','off');
EEG = eeg_checkset( EEG );

eeglab redraw;
erplab redraw;

cd(pDset_ICA_pruned); % setting default path for saving ICA-pruned datasets)
%%