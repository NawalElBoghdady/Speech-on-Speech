function options = setDirectories(options)

    if ~exist(options.resultsDir, 'dir')
        makeDir = questdlg('Create results directory?' , ...
            'Result directory', ...
            'Yes','No','Yes');
        if strcmp(makeDir, 'Yes')
            mkdir(options.resultsDir);
        end
    end
    if ~exist(options.maskerDir, 'dir')
        makeDir = questdlg('Create maskers directory?', ...
            'Markers directory', ...
            'Yes','No','Yes');
        if strcmp(makeDir, 'Yes')
            mkdir(options.maskerDir);
        end
        mkdir(options.maskerDir);
    end

    if ~exist(options.sentencesDir, 'dir')
        answer=inputdlg('Where are the sentences?', 'Directory with sentences', ...
            [1 length(options.sentencesDir) + 5], options.sentencesDir);
        if ~exist(answer{:}, 'dir')
            error('Wrong path for sentences')
        end
    end

    if ~exist(options.PathToStraight, 'dir')
        answer=inputdlg('Where is straight?', 'Straight directory', ...
            [1 length(options.PathToStraight) + 5], options.PathToStraight);
        if ~exist(answer{:}, 'dir')
            error('Wrong path for straight')
        end
    end


end