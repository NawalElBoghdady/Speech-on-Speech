function stimuli = create_stimuli(p, options)
    
    display('subject')
    
     conditions = sscanf(p.FileNames{p.i}, sprintf('%s%%03d_f0%%d_vtl%%f_snr%%d', p.ManVrouw));
%     target_signal_pre = wavread(fullfile('sentences', sprintf('%s%03d.wav', p.ManVrouw, conditions(1))));
    target_signal_pre = audioread([options.sentencesDir, sprintf('%s%03d.wav', p.ManVrouw, conditions(1))]);

    list = p.MaskerLists(1) + round(rand()*(p.MaskerLists(2) - p.MaskerLists(1)));
    index1 = round((((list-1)*13)+round(rand()*13)));
    index2 = index1;
    while index2 == index1
        list = p.MaskerLists(1) + round(rand()*(p.MaskerLists(2) - p.MaskerLists(1)));
        index2 = round((((list-1)*13)+round(rand()*13)));
    end

    file2load = [options.maskerDir, sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index1, conditions(2), conditions(3))];
    if exist(file2load, 'file') ~= 0
%         masker1 = wavread(fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index1, conditions(2), conditions(3))));
        masker1 = audioread(file2load);
    else
%         masker1 = wavread(fullfile('sentences', sprintf('%s%03d.wav', p.ManVrouw, index1)));
%        [p, masker2] = modify_masker(p, masker2, conditions, p.fs, p.ManVrouw, index2, options);
        [p, masker1] = modify_masker(p, conditions, p.fs, p.ManVrouw, index1, options);          %%%%%%
    end

    file2load = [options.maskerDir,  sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index2, conditions(2), conditions(3))];
    if exist(file2load, 'file') ~= 0
%         masker2 = wavread(fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index2, conditions(2), conditions(3))));
        masker2 = audioread(file2load);
    else
%         masker2 = wavread(fullfile('sentences', sprintf('%s%03d.wav', p.ManVrouw, index2)));
%        [p, masker2] = modify_masker(p, masker2, conditions, p.fs, p.ManVrouw, index2, options);
        [p, masker2] = modify_masker(p, conditions, p.fs, p.ManVrouw, index2, options);
    end


    target_signal_pre = 0.98 * target_signal_pre / max(abs(target_signal_pre));
    start = find(abs(target_signal_pre)>.02, 1, 'first');
    target_signal = target_signal_pre(start:end);
    target_signal = [zeros(1, round(p.fs*0.5)) target_signal'];

    % masker 1 start
    start = round(rand()*(length(masker1)-p.fs));
    masker1 = masker1(start:end);

    start = round(rand()*(length(masker2)-p.fs));
    masker2 = masker2(start:end);

    masker1 = cosgate(masker1, p.fs, 2e-3);
    masker2 = cosgate(masker2, p.fs, 2e-3);

    masker = [masker1' masker2'];

    len_diff = length(masker) - length(target_signal);

    while len_diff < 0
        additional_masker = get_additional_masker(p, conditions, options);
        masker = [masker additional_masker'];
        len_diff = length(masker) - length(target_signal);
        fprintf('extending masker\n');
    end

    if len_diff > round(0.5*p.fs)
        target_signal = [target_signal zeros(1, round(0.5*p.fs))];
        masker = masker(1:length(target_signal));
    else
        target_signal = [target_signal zeros(1, len_diff)];
    end

    % attenuation
    attenuate = p.Target_rms / rms(target_signal);
    target_signal = target_signal*attenuate;

    masker_rms = p.Target_rms/(10^(conditions(4)/20));

    attenuate = masker_rms / rms(masker);
    masker = masker * attenuate;

    stimuli = target_signal+masker;

    max_stim = max(abs(stimuli));
    if max_stim > 1
        stimuli = 0.98*stimuli / max(abs(stimuli));
        max_stim2 = max(abs(stimuli));
        fprintf('Stimuli attenuated by %.2f%%', 100*(max_stim-max_stim2) / max_stim);
    end

end