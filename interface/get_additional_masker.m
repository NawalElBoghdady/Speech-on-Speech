function additional_masker = get_additional_masker(p, conditions, options)

    list = p.MaskerLists(1) + round(rand()*(p.MaskerLists(2) - p.MaskerLists(1)));
    index3 = round((((list-1)*13)+round(rand()*13)));

    if exist(fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index3, conditions(2), conditions(3))), 'file') ~= 0
        masker3 = wavread(fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', p.ManVrouw, index3, conditions(2), conditions(3))));
    else
        masker3 = wavread(fullfile('sentences', sprintf('%s%03d.wav', p.ManVrouw, index3)));
        [p, masker3] = modify_masker(p, masker3, conditions, p.fs, p.ManVrouw, index3);
    end

    start = round(rand()*(length(masker3)-p.fs));

    additional_masker = masker3(start+1:end);
    additional_masker = cosgate(additional_masker, p.fs, 2e-3);
end
