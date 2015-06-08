function options = experimentOptions

    % EXPERIMENT OPTIONS
    options.resultsDir = '~/speechOnSpeech/analysisMatFiles/';
    options.imagesDir = '~/speechOnSpeech/images/';
    options.maskerDir = '~/speechOnSpeech/maskerFiles';
    options.sentencesDir = '~/speechOnSpeech/sentences';
    options.PathToStraight = '/home/paolot/gitStuff/Beautiful/lib/STRAIGHTV40_006b/';

    [b, s] = is_test_machine;
    if ~strcmp(s, '12-000-4372')
        options.PathToStraight = genpath(fullfile('..', 'straight', 'STRAIGHT'));
    end

    options = setDirectories(options);

    def = 'sub001.mat';
    resFiles = dir([options.resultsDir '/*.mat']);
    if ~isempty(resFiles)
        def = sprintf('sub%03i.mat', length(resFiles)+1);
    end
    sub = inputdlg('Participant ID:', 'Input', 1, {def});

    % PARTICIPANTS OPTIONS
    
    options.Subject = sub{:};

    options.f0 = [0, 4, 8];
    options.vtl = [0, 0.75, 1.5];
    options.snr = -6;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%   Order: [training1 test1 training2 test2] %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    options.fs = 44100;
    options.Target_rms = 0.05;
    options.SamplesPerCondition=[1, 13, 1, 13, 13, 13];
    options.ManVrouw = {'Man','Man','Vrouw','Vrouw', 'Man', 'Vrouw'};
    options.Phase = {'Training1','Test1','Training2','Test2', 'Test3', 'Test4'};
    options.IndexStartingPoint = [1 27 1 27, 144, 144];
    options.MaskerLists = [27, 31];
    

    
end