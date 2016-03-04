% eeg_DataImport_merge_run.m
% Matlab script for EEG:
%   (1)running the main script for importing individual data(.edf)
%   (2)merging(appending) datasets by selecting Ss# (single or multiple)

% check sample rate, should be 256

clear all % clear all objects in Workspace
close all % delete all unhidden figures
clc       % clear Command Window
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

Path_n_Name='eeg_Path_n_Name'; %Path and Name definition script *in the same folder*
open([pwd, filesep, Path_n_Name,'.m']);
run(Path_n_Name);

choice = questdlg('Which task would  you like to run?', 'Task', 'Import individual data.edf file(s)','Merge(append) datasets', 'Import individual data.edf file(s)');
switch choice
    %% import individual data.edf file(s)
    case 'Import individual data.edf file(s)'
        
        cd(pData);
        main_import='eeg_DataImport_main'; %data import main script *in the same folder*
        open([pwd, filesep, main_import,'.m']);
        
        choice = questdlg('Which data file(s) would you like to import?', 'Data Processing Methods', 'Choose one file','Run all files','Run all newly-added file(s)', 'Choose one file');
        switch choice
        case 'Choose one file'
            fName=uigetfile('*.edf');
            EEG = pop_biosig(fullfile(pData,fName), 'channels',[1:9] ,'importevent','off','importannot','off','blockepoch','off');
            
            cd(pStart);
            run(main_import);

            fprintf('Subject = %s\n', Ss);
            fprintf('Session = %s\n', Sn);
            fprintf('Sampling Rate = %d\n', EEG.srate);
            fprintf('# of Channel = %d\n', EEG.nbchan);
            fprintf('# of events = %d\n', event_no);

            msgbox(strcat(EEG.filename,' is saved.  # of events = ',num2str(event_no)));

        case 'Run all files'
            fNames = dir( fullfile(pData,'*.edf') );
            fNames={fNames.name};

            for f=1:length(fNames)
                fName=fNames{f};
                EEG = pop_biosig(fullfile(pData,fName), 'channels',[1:9] ,'importevent','off','importannot','off','blockepoch','off');
                cd(pStart);
                run(main_import);

            end
            fprintf('Number of files processed: %d\n', f);

            save('fNames.mat','fNames');
            msgbox(strcat('Number of files processed:  ', num2str(f)));

        case 'Run all newly-added file(s)'
            load('fNames.mat');
            fNames_re = dir( fullfile(pData,'*.edf') );
            fNames_re={fNames_re.name};
            fNames_chk=~ismember(fNames_re,fNames);
            fNames_new=fNames_re(fNames_chk);
            f_diff=numel(fNames_re)-numel(fNames);

            for f=1:length(fNames_new)
                fName=fNames_new{f};
                EEG = pop_biosig(fullfile(pData,fName), 'channels',[1:9] ,'importevent','off','importannot','off','blockepoch','off');
                
                cd(pStart);
                run(main_import);

            end
            fprintf('Number of files processed: %d\n', f);
            fprintf('Number of files difference: %d\n', f_diff);

            fNames=fNames_re;
            save('fNames.mat','fNames');
            msgbox(strcat('Number of files processed:  ', num2str(f), '. Number of files difference: ', num2str(f_diff)));


        end
        
        eeglab redraw;
        erplab redraw;
        
        cd(pStart);

    
    %% Merge(append) datasets
        case 'Merge(append) datasets'
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

                EEG = eeg_checkset( EEG );
                EEG = pop_mergeset( ALLEEG, [1:n], 0);
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n+1,'setname',Ss,'savenew',strcat(pDset_mer,Ss),'gui','off');
                ALLEEG = pop_delset( ALLEEG, [1:n+1] );
                
                eeglab redraw;
                erplab redraw;

             end
             
            msgbox('Done.');
       
            cd(pStart);
end