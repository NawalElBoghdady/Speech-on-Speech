function [p, masker_new] = modify_masker(p, conditions, fs, ManVrouw, index, options)    

    p.InstructionHandle4= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction4, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.InstructionHandle4, 'String', 'Extracting data... Please be patient', 'Visible', 'on');

    p.InstructionHandle5= uicontrol('Parent', p.f1, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction5, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.InstructionHandle5, 'String', 'Extracting data... Please be patient', 'Visible', 'on');

    pause(0.05) % paol8: why is this pause here?

    masker = audioread([options.sentencesDir, sprintf('%s%03d.wav', p.ManVrouw, index)]);
    
    if exist(fullfile('analysis mat files', sprintf('%s%03d.mat',ManVrouw, index)), 'file') ~= 0
        load (fullfile('analysis mat files', sprintf('%s%03d.mat',ManVrouw, index)));
    else
        fprintf('extracting f0\n')
        [f0raw1,vuv]=MulticueF0v14(masker,fs);
        ap=exstraightAPind(masker,fs,f0raw1);
        n3sgram=exstraightspec(masker,f0raw1.*vuv,fs);
        f0raw1(f0raw1<65)=0;
        save(fullfile('analysis mat files', sprintf('%s%03d.mat',ManVrouw, index)), 'f0raw1', 'vuv', 'ap', 'n3sgram')
    end

    switch ManVrouw
        case 'Man'
            f0shift = f0raw1*2.^(conditions(2)/12);
            p2.frequencyAxisMappingTable = 2.^(conditions(3)/12);
        case 'Vrouw'
            f0shift = f0raw1*2.^(-conditions(2)/12);
            p2.frequencyAxisMappingTable = 2.^(-conditions(3)/12);
    end

    fprintf('synthesizing\n');
    masker = exstraightsynth(f0shift.*vuv,n3sgram,ap,fs, p2);

    masker = 0.98*masker / abs(max(masker));
    start = find(abs(masker)>.02, 1, 'first');
    endx = find(abs(masker)>.02, 1, 'last');

    masker_new = masker(start:endx);

%     wavwrite(masker_new, fs, fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', ManVrouw, index, conditions(2), conditions(3))));
    audiowrite([options.maskerDir, sprintf('%s%03d_f0%d_vtl%.2f.wav', ManVrouw, index, conditions(2), conditions(3))], masker_new, fs);
    set(p.InstructionHandle5, 'Visible', 'off');
    set(p.InstructionHandle4, 'Visible', 'off');
end
