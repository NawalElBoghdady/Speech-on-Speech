% 1 = pause
% 2 = unpause
% space = next

% in case of crash: comment line 13 "save backup.mat" 
% and manually adjust line 23: for Phase_index = X : 6 --> X = where you
% crashed (1, 2, 3, 4), corresponding to (training1, test1, training2,
% test2)

options = experimentOptions;
addpath(options.PathToStraight);


%Man097_f04_vtl1.50_snr-6
% for Phase_Index=1:6
%     switch Phase_Index %6 phases??
%         case {3, 4, 6}
%             %do_nothing
%         case {1, 2, 5}
phases = [1, 2, 5];
for phaseIndex = 1:length(phases);

    p = interface(options, phases(phaseIndex));
    filename = [options.Subject(1:strfind(options.Subject, '.mat')-1) ...
        '_p' int2str(phases(phaseIndex)) '.mat'];
    save(filename, 'p');

end
  
rmpath(options.PathToStraight);



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