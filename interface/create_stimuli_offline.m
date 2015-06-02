clear all
clc
listing = dir(fullfile('analysis mat files', '*.mat'));

Options = struct();
Options.f0 = [0, 6, 12];
Options.vtl = [0, 0.33, 0.66, 1, 1.33, 1.66, 2]; 
Options.snr = [-6];

PathToStraight = fullfile('..', 'straight', 'STRAIGHT');
addpath(genpath(PathToStraight));

fs=44100;

for i=67:length(listing)
    i
    switch listing(i).name(1:5)
        case 'Man'
            load(fullfile('analysis mat files',sprintf('Man%03d.mat', str2num(listing(i).name(4:6)))));
        case 'Vrouw'
            load(fullfile('analysis mat files',sprintf('Vrouw%03d.mat', str2num(listing(i).name(6:8)))));
        otherwise
            error('no mat file found')
    end
    
    for f0=1:length(Options.f0)
        for vtl = 1:length(Options.vtl)
            
            switch listing(i).name(1:5)
                case 'Man'
                    f0shift = f0raw1*2.^(Options.f0(f0)/12);
                    p2.frequencyAxisMappingTable = 2.^(Options.vtl(vtl)/12);               
                case 'Vrouw'
                    f0shift = f0raw1*2.^(-Options.f0(f0)/12);
                    p2.frequencyAxisMappingTable = 2.^(-Options.vtl(vtl)/12);              
            end
            
            masker = exstraightsynth(f0shift.*vuv,n3sgram,ap,fs, p2);

            masker = 0.98*masker / abs(max(masker));
            start = find(abs(masker)>.02, 1, 'first');
            endx = find(abs(masker)>.02, 1, 'last');
        
            masker_new = masker(start:endx);
            
            
            switch listing(i).name(1:5)
                case 'Man'
                    wavwrite(masker_new, fs, fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', 'Man', str2num(listing(i).name(4:6)), Options.f0(f0), Options.vtl(vtl))));
                case 'Vrouw'
                    wavwrite(masker_new, fs, fullfile('masker files', sprintf('%s%03d_f0%d_vtl%.2f.wav', 'Vrouw', str2num(listing(i).name(6:8)), Options.f0(f0), Options.vtl(vtl))));
            end
            
             
        end
    end
end
