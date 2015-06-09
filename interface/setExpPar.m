function [p] = setExpPar(Options, Phase_Index)
% function [p] = initialize_parameters(Options, Phase_Index)

%  creates the parameter struct p based on the Options
%  and phase of the experiment (training vs test).

    p = load('VU_zinnen.mat');
    p.PhaseIndex = Phase_Index;

    assignin('caller', 'User2_Sitch', [1 0]) %instead of creating a var and passing it to the caller environment
    assignin('caller', 'User_Sitch', 1)     %create these vars (User(2)_Sitch) in the caller environment/workspace, and assign these values to them.

    p.Init = 1;
    p.Continu = 1;

    p.Player.Running = 'off';
    p.i = 1;
    p.i2 = 1;
    p.AnnotationsAvailable = p.i; % paol8 |WTF| is this???



    p.SamplesPerCondition = Options.SamplesPerCondition(Phase_Index);
    p.ManVrouw = Options.ManVrouw{Phase_Index};
    p.Subject = Options.Subject;
    p.Phase = Options.Phase{Phase_Index};

    for f0 = 1:length(Options.f0)
        for vtl = 1:length(Options.vtl)
            for snr = 1:length(Options.snr)
                p.ConditionsNames{f0, vtl, snr} = sprintf('f0%d_vtl%.2f_snr%d', Options.f0(f0), Options.vtl(vtl), Options.snr(snr));
                p.ConditionsCounts(f0, vtl, snr) = 0;
                p.ConditionsCorrect(f0, vtl, snr) = 0;
            end
        end
    end

    p.Conditions.f0 = Options.f0;
    p.Conditions.vtl = Options.vtl;
    p.Conditions.snr = Options.snr;
    p.MaskerLists = Options.MaskerLists;
    p.IndexStartingPoint = Options.IndexStartingPoint(Phase_Index);
    p.fs = Options.fs;
    p.Target_rms = Options.Target_rms;

    
end