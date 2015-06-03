% 1 = pause
% 2 = unpause
% space = next

% in case of crash: comment line 13 "save backup.mat" 
% and manually adjust line 23: for Phase_index = X : 6 --> X = where you
% crashed (1, 2, 3, 4), corresponding to (training1, test1, training2,
% test2)
 
close all
clear all 
clc
save backup.mat

resultsDir = '~/speechOnSpeech/analysisMatFiles';

% this is OK only the first time this program is run
if ~exist(resultsDir, 'dir')
    makeDir = questdlg('Create results directory?', ...
        'Result directory', ...
        'Yes','No','No');
    if strcmp(makeDir, 'Yes')
        mkdir('~/speechOnSpeech/analysisMatFiles');
    end
end
if ~exist('~/speechOnSpeech/maskerFiles', 'dir')
    makeDir = questdlg('Create maskers directory?', ...
        'Markers directory', ...
        'Yes','No','No');
    if strcmp(makeDir, 'Yes')
        mkdir('~/speechOnSpeech/analysisMatFiles');
    end
    mkdir('~/speechOnSpeech/maskerFiles');
end

if ~exist('~/speechOnSpeech/sentences', 'dir')
    disp('sentences not available')
%     error('sentences not available')
end

PathToStraight = '/home/paolot/gitStuff/Beautiful/lib/STRAIGHTV40_006b/';
[b, s] = is_test_machine;
if ~strcmp(s, '12-000-4372')
    PathToStraight = genpath(fullfile('..', 'straight', 'STRAIGHT'));
end
if ~exist(PathToStraight, 'dir')
    error('Wrong path for straight')
end



%Man097_f04_vtl1.50_snr-6
for Phase_Index=1:6
    switch Phase_Index %6 phases??
        case {3, 4, 6}
            %do_nothing
        case {1, 2, 5}

            addpath(PathToStraight);

            %             Options.Subject = '1'; %SUBJECT Number IS HARDCODED!!!
            
            prompt = {'Enter participant:'};
            dlg_title = 'Input';
            num_lines = 1;
            def = {'sub001.mat'};
            resFiles = dir([resultsDir '/*.mat']);
            if ~isempty(resFiles)
                def = {sprintf('sub%03i.mat', length(resFiles)+1)};
            end
            Options.Subject = inputdlg(prompt,dlg_title,num_lines,def);
            
            Options.f0 = [0, 4, 8];
            Options.vtl = [0, 0.75, 1.5]; 
            Options.snr = [-6];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%   Order: [training1 test1 training2 test2] %%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            Options.fs = 44100;
            Options.Target_rms = 0.05;
            Options.SamplesPerCondition=[1, 13, 1, 13, 13, 13];
            Options.ManVrouw = {'Man','Man','Vrouw','Vrouw', 'Man', 'Vrouw'};                         
            Options.Phase = {'Training1','Test1','Training2','Test2', 'Test3', 'Test4'};
            Options.IndexStartingPoint = [1 27 1 27, 144, 144];
            Options.MaskerLists = [27, 31];                                 

            p = interface(Options, Phase_Index);
            save(fullfile(sprintf('subject%s', Options.Subject), sprintf('%s', p.Phase)), 'p');

            rmpath(PathToStraight);
     end
end
  



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % LISTS % % % LISTS % % % LISTS % % % LISTS % % % LISTS % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % %                                                               % % %
% % %  training 1        lists 1:2       indexes 1:26        MALE   % % % 
% % %  test1             lists 3:26      indexes 27:338      MALE   % % % 
% % %  male maskers      lists 27:31     indexes 339:403     MALE   % % %
% % %  training2         lists 40:41     indexes 507:533     FEMALE % % %
% % %  test2             lists 42:65     indexes 534:845     FEMALE % % %
% % %  female maskers    lists 66:70     indexes 846:910     FEMALE % % %
% % %                                                               % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % LISTS % % % LISTS % % % LISTS % % % LISTS % % % LISTS % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 