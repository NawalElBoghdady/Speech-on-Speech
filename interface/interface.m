function p = interface(Options, Phase_Index)

%% function p = interface(Options, Phase_Index)
%
% function which performs all necessary computations (SOS exp) to acquire
% the subject's response in struct 'p'.
% The 'Options' struct is created in call_interface
%
% NOTE: Most function definitions are included at the bottom of this script! 
%
% Function modified by Nawal El Boghdady on 01-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % paol8 got rid of this shit!
    % load('backup.mat') %this struct contains a backup of everything, even the GUIs!
    
    %backup.mat contains the following parameters:
    %   Options     <struct>
    %   p           <struct>
    %   Phase_Index <scalar INT>
    %   pressed     <scalar INT>
    %   stimuli     <row vector>
    %   User2_Sitch <2-element row vector>
    %   User_Sitch  <scalar INT>
    %   delay        <scalar INT>


    if exist('p', 'var') %check if struct 'p' was loaded from backup.mat
        p = initialize_saved(p);
    else
        %else create 'p'
        p = setExpPar(Options, Phase_Index);
        p = make_file_names(p);
    end
    p = guiDefinition(p, Options);
    delay=0;
    pressed = 0;

    % The while loop contains the core of the GUI. The loop runs from the beginning of some phase of an experiment,
    % all the way until the end. It pauses after every loop for .1 seconds just to reduce the load on the computer.

    while (p.Continu==1  || ~isempty(p.AnnotationsAvailable))

        if delay == 0

            set(p.InstructionHandle6, 'Visible', 'off');
            set(p.InstructionHandle7, 'Visible', 'off');

            switch User_Sitch

                % cases 1-4: initialization & introductions
                case 1
                    User_Sitch = 0;
                    p.current_situation = 1;
                    p = set_progress_bar(p, p.f2, p.i2, 'on', p.PosBar2);
                    p = initialize_GUI(p);
                case 2
                    User_Sitch = 0;
                    p.current_situation = 2;
                    p = set_GUI_case2(p);
                case 3
                    p.current_situation = 3;
                    p = set_GUI_case3(p);
                case 4
                    if strcmp(p.Player.Running, 'off')==1
                        p.current_situation = 4;
                        User_Sitch = 0;
                        p = set_GUI_case4(p);
                    end

                    % cases 10-12: play and repeat cycle
                case 10
                    p.current_situation = 10;
                    p = set_progress_bar(p, p.f1, p.i, 'on', p.PosBar1);
                    stimuli = create_stimuli(p, Options);
                    p.Player = audioplayer(stimuli, p.fs);
                    play(p.Player);
                    p = set_GUI_case10(p);
                case 11
                    if strcmp(p.Player.Running, 'off') == 1
                        p.current_situation = 11;
                        User_Sitch = 0;
                        p = set_GUI_case11(p);
                    end
                case 12
                    User_Sitch = 0;
                    p.current_situation = 12;
                    p.i = p.i+1;
                    p = set_GUI_case12(p);

                    % case 13:14 (and 12): good bye messages
                case 13
                    p.current_situation = 13;
                    User_Sitch = 0;
                    p = set_GUI_case13(p);
                case 14
                    p.current_situation = 14;
                    User_Sitch = 0;
                    p = set_GUI_case14(p);
                case 15
                    p.current_situation = 15;
                    User_Sitch = 0;
                    set(p.ImagePlay, 'Visible', 'off')
                    set(p.ImageJohnHappy, 'Visible', 'off')
                    set(p.Text, 'Visible', 'off')
                    set(p.ImageArrow2, 'Visible', 'off')
                    set(p.InstructionHandle1, 'String', 'delaying for Nikki and/or Mike -_-', 'Visible', 'on');
                    if strcmp(p.Phase , 'Test4')==1
                        set(p.InstructionHandle1, 'Visible', 'off');
                    end
                    p.Continu = 0;

                    % saved case
                case 20
                    p.current_situation = 20;
                    User_Sitch = 0;
                    p = set_GUI_saved(p);


                    % new training repeat cycle
                case 25
                    p.current_situation = 25;
                    p = set_progress_bar(p, p.f1, p.i, 'on', p.PosBar1);
                    stimuli = create_stimuli(p, Options);
                    p.Player = audioplayer(stimuli, p.fs);
                    play(p.Player);
                    p = set_GUI_case25(p);
                case 26
                    if strcmp(p.Player.Running, 'off') == 1
                        p.current_situation = 26;
                        User_Sitch = 0;
                        p = set_GUI_case26(p);
                    end
                case 29
                    User_Sitch = 0;
                    p.current_situation = 29;
                    p = set_GUI_case27(p);
                case 27
                    User_Sitch = 0;
                    p.current_situation = 27;
                    %p = set_GUI_case27(p);
                    play(p.Player);
                case 28
                    if strcmp(p.Player.Running, 'off') == 1
                        p.i = p.i+1;
                        p.current_situation = 25;
                        p = set_GUI_case28(p);
                    end


            end

            if pressed == 1 %?checks if any buttons have been pressed. If this is true, get_user_sitch is called,
                %which will determine the next step for the GUI.
                pressed = 0;
                [User_Sitch, p] = get_user_sitch(p, p.current_situation);
            end
            %Once the User_Sitch variable has been set in function ?get_user_sitch?,
            %one of the cases in the first switch statement gets activated.
            %Here a function is usually called that actually modifies the GUI (set_GUI_case_X).
        else
            set(p.InstructionHandle6, 'String', 'Paused', 'Visible', 'on');
            set(p.InstructionHandle7, 'String', 'Paused', 'Visible', 'on');
        end

        switch User2_Sitch(1)
            case 1
                if ~isempty(p.AnnotationsAvailable)
                    User2_Sitch(1) = 0;
                    p=set_buttons(p); %shows buttons for choosing which words were wrong
                end
            case 2
                User2_Sitch(1) = 0;
                p = modify_score(p, User2_Sitch);
            case 3
                User2_Sitch(1) = 0;
                p = save_score(p);
                if p.Continu == 0 && isempty(p.AnnotationsAvailable)
                    close all
                end
%                 save 'backup.mat' % paol8: saving all variables in the workspace... are you nuts?!?     

        end
        pause(0.1);
    end

end
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%% %%% SCORING & GUI %%% %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% 


function p = set_buttons(p)
    VU_index = sscanf(p.FileNames{p.AnnotationsAvailable(1)}, sprintf('%s%%03d', p.ManVrouw));

    switch p.ManVrouw
        case 'Man'
            sentence = p.VU_zinnen{VU_index};
        case 'Vrouw'
            sentence = p.VU_zinnen{VU_index+507};
    end

%     line_cell_cell=textscan(sentence,'%s',10,'delimiter',' ');
%     p.Words=line_cell_cell{1};
    p.Words = regexp(sentence, ' ', 'split');
    
    [screenSub, screenExp] = getScreens;
    
    widthSubScrn = screenSub(3);
    widthExpScreen = screenExp(3);
    heightSubScrn =  screenSub(4);
    heightBigExpScreen = screenExp(4);

    
    p.Spacing = (widthExpScreen/(length(p.Words))) - widthExpScreen/25;
    p.SentenceScore = ones(length(p.Words), 1);

    for i2=1:length(p.Words)
        p.Instruction = uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', ...
            [p.PosButtons(1)+p.Spacing*(i2-1)-0.25*p.PosButtons(3) p.PosButtons(2)+1.25*p.PosButtons(4) p.PosButtons(3)*1.75 p.PosButtons(4)*1.2], ...
            'FontSize', 14, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
        set(p.Instruction, 'String', p.Words{i2})
        p.ImageWrongRightHandle(i2) = axes('Parent', p.f2, 'Units', 'pixel','Position', [p.PosButtons(1)+p.Spacing*(i2-1) p.PosButtons(2) p.PosButtons(3) ...
            p.PosButtons(4)], 'XTick', [], 'YTick', []);
        axes(p.ImageWrongRightHandle(i2));
        image_handle=image(p.ImreadRight);
        set(p.ImageWrongRightHandle(i2), 'Visible','off')
        set(image_handle,'ButtonDownFcn',@(h,e)(assignin('caller', 'User2_Sitch',  [2 i2])))
    end

    confirm_image_axes_handle = axes('Visible', 'off', 'Parent', p.f2, 'Units', 'pixel','Position', p.PosBottom2, 'XTick', [], 'YTick', []);
    axes(confirm_image_axes_handle);
    p.ImageConfirm=image(p.ImreadConfirm);
    set(p.ImageConfirm, 'Visible','on')
    set(confirm_image_axes_handle, 'Visible','off')
    set(p.ImageConfirm,'ButtonDownFcn',@(h,e)(assignin('caller', 'User2_Sitch',  [3 0])))

end

function p = modify_score(p, User2_Sitch)
    axes(p.ImageWrongRightHandle(User2_Sitch(2)));

    switch p.SentenceScore(User2_Sitch(2))
        case 1
            p.SentenceScore(User2_Sitch(2)) = 0;
            WrongRightHandel=image(p.ImreadWrong);
        case 0
            p.SentenceScore(User2_Sitch(2)) = 1;
            WrongRightHandel=image(p.ImreadRight);
    end

    set(p.ImageWrongRightHandle(User2_Sitch(2)), 'Visible','off')
    set(WrongRightHandel,'ButtonDownFcn',@(h,e)(assignin('caller', 'User2_Sitch',  [2 User2_Sitch(2)])))
end

function p = save_score(p)

%     display('saving');
    [conditions] = sscanf(p.FileNames_indexed{p.i2}, sprintf('%s%%03d_f0%%d_vtl%%d_snr%%d', p.ManVrouw));

    p.ConditionsCounts(conditions(2), conditions(3), conditions(4)) = ...
        p.ConditionsCounts(conditions(2), conditions(3), conditions(4)) + length(p.Words);
    p.ConditionsCorrect(conditions(2), conditions(3), conditions(4)) = ...
        p.ConditionsCorrect(conditions(2), conditions(3), conditions(4)) + sum(p.SentenceScore);

    clf(p.f2)
    assignin('caller', 'User2_Sitch', [1 0])          % set next annotations
    p.i2 = p.i2+1;
    p = set_progress_bar(p, p.f2, p.i2, 'on', p.PosBar2);

    tmp = [];
    for i=2:length(p.AnnotationsAvailable)
        tmp(i-1) = p.AnnotationsAvailable(i);
    end
    p.AnnotationsAvailable = tmp;

    p.InstructionHandle2= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction2, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    WhereUseris = sprintf('User: %d\nYou: %d',p.i, p.i2);
    WhereUseris = textwrap(p.InstructionHandle2, {WhereUseris});
    set(p.InstructionHandle2, 'String', WhereUseris, 'Visible', 'on');
    p.InstructionHandle6= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosPause2, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.InstructionHandle6, 'String', 'Paused', 'Visible', 'off');
    
    display('saved');

end


%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%% %%%%%%%% GUI %%%%%%%% %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% 

function p = initialize_GUI(p)

    switch p.Phase
        case 'Training1'
            instr_0 = 'Hello, and welcome to the experiment. \n\nYou are currently seated in a soundproof, anechoic chamber, which means that no matter how hard you scream, nobody will hear you.\n\nLets begin the experiment.';
        case 'Test1'
            instr_0 = 'We will now begin with Trial #1. It is equivalent to your training, so im sure you will do fine!\n\nBy the way, don''t worry if you don''t understand the whole sentence, just repeat the parts that you do understand. \n\nGood luck!\n\n';
        case 'Training2'
            instr_0 = 'Welcome to your second training session. \n\nHere we will become familiar with a new voice. We''ll follow the same procedure as your first training session, so sit back and relax.';
        case 'Test2'
            instr_0 = 'Welcome to Trial #2.  You know what to do by now. \n\nGood luck!';
        case 'Test3'
            instr_0 = 'Hello again, and welcome to Trial #3! Here we will be listening to the male voice again. Good luck!';
        case 'Test4'
            instr_0 = 'Hi! Welcome to your final Trial! We will be listening to the female''s voice again this time. Good luck!';
    end

    instr = strrep(instr_0, '\n', sprintf('\n'));
    instr = textwrap(p.Text, {instr});
    set(p.Text, 'String', instr, 'Visible', 'on');
    set(p.ImageJohnIntro, 'Visible','on')
    set(p.ImageArrow2, 'Visible','on')

    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

end


function p = set_GUI_case2(p)
    instr_0 = 'My name is John by the way, and i will guide you through the experiment. \n\First, we will begin with some training. \n\nHere we will introduce you to the voice of a man. You will have to try and recognize this voice in future trials, but for now just sit back and relax.';
    instr = strrep(instr_0, '\n', sprintf('\n'));
    instr = textwrap(p.Text, {instr});
    set(p.Text, 'String', instr);
    set(p.ImageJohnIntro, 'Visible','off')
    set(p.ImageJohnHappy, 'Visible','on')

    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});
end
                
                

function p = set_GUI_case3(p)
    set(p.Text, 'Visible', 'off');
    set(p.ImageJohnHappy, 'Visible','off')
    set(p.ImageJohnIntro, 'Visible','off')
    set(p.ImageArrow2, 'Visible','off')
    set(p.InstructionHandle1, 'String', 'Playing...')
    set(p.ImageSpeaker, 'Visible','on')
    switch p.Phase
        case 'Training1'
            [signal, fs] = wavread('man_training1.wav');
        case 'Training2'
            [signal, fs] = wavread('female_training2.wav');
    end

    % attenuation (training)
    attenuate = p.Target_rms/rms(signal);
    signal = signal*attenuate;

    p.Player = audioplayer(signal, fs);
    play(p.Player)

    assignin('caller', 'User_Sitch', 4)
end


function p = set_GUI_case4(p)
    set(p.ImageJohnHappy, 'Visible','off')
    set(p.ImageSpeaker, 'Visible','off')
    set(p.InstructionHandle1, 'Visible', 'off')
    set(p.ImageArrow2, 'Visible','on')
    set(p.ImageJohnNeutral, 'Visible','on')

    switch p.Phase
        case 'Training1'
            instr_0 = 'Great. You will now hear the two voices. Try to ignore the voice that starts first, and repeat the second voice. It will start 0.5 seconds after the first voice. \n\nBeware, they may be very similar!';
        case 'Training2'
            instr_0 = 'Great. We will now introduce a second voice again.';
    end

    instr = strrep(instr_0, '\n', sprintf('\n'));
    instr = textwrap(p.Text, {instr});
    set(p.Text, 'String', instr, 'Visible', 'on');

    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});
end                


function p = set_GUI_case10(p)
    set(p.ImageArrow2, 'Visible','off')
    set(p.ImageArrow, 'Visible','off')
    set(p.ImageVoice, 'Visible','off')
    set(p.ImageJohnNeutral, 'Visible','off')
    set(p.ImageJohnIntro, 'Visible','off')
    set(p.Text, 'Visible', 'off');
    set(p.ImageSpeaker, 'Visible','on')
    set(p.InstructionHandle1, 'String', 'Playing..', 'Visible', 'on')

    p.InstructionHandle3= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction3, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.InstructionHandle3, 'String', 'Play', 'Visible', 'on');

    assignin('caller', 'User_Sitch', 11)
end



function p = set_GUI_case11(p)
    pause(0.1)
    set(p.ImageSpeaker, 'Visible','off');
    set(p.InstructionHandle1, 'String', 'Please repeat')
    set(p.ImageVoice, 'Visible','on')
    set(p.ImageArrow, 'Visible','on')

    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

    p.InstructionHandle3= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction3, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.InstructionHandle3, 'String', 'Repeat', 'Visible', 'on');

end


function p = set_GUI_case12(p)
    if p.i <= p.TotalSampleLength
        p.AnnotationsAvailable(end+1) = p.i;
        assignin('caller', 'User_Sitch', 10)
    else
        p = set_progress_bar(p, p.f1, p.i, 'off', p.PosBar1);
        set(p.ImageVoice, 'Visible','off')
        set(p.ImageArrow, 'Visible','off')
        set(p.InstructionHandle1, 'Visible', 'off')
        switch p.Phase
            case 'Test1'
                instr_0 = '\nZZZZzzzzz ...... ZZZZzzzzzz ..... ZZZzzzzz';
                set(p.ImageJohnSleeping, 'Visible','on')
            case 'Test2'
                instr_0 = 'That concludes trial #2. Well done! Would you like a break?';
                set(p.ImageJohnHappy, 'Visible','on')
            case 'Test3'
                %instr_0 = 'That concludes trial #3. We have free coffee, thee and hot choclate by the way :)';
                instr_0 = 'Congradulations, you have succesfully completed the experiment!\n\nI would like to thank you for your participation. Perhaps your data will contribute towards enriching auditory perception for the hearing-impaired all over the world!\n\nPerhaps one day we will meet again, thank you and good bye!';
                set(p.ImageJohnHappy, 'Visible','on')
            case 'Test4'
                instr_0 = 'Congradulations, you have succesfully completed all four trials!\n\nI would like to thank you for your participation. Perhaps your data will contribute towards enriching auditory perception for the hearing-impaired all over the world!\n\nPerhaps one day we will meet again, thank you and good bye!';
                set(p.ImageJohnHappy, 'Visible','on')
        end
        instr = strrep(instr_0, '\n', sprintf('\n'));
        instr = textwrap(p.Text, {instr});
        set(p.Text, 'String', instr, 'Visible', 'on');
        set(p.ImageArrow2, 'Visible','on')

        set(p.f2, 'KeyPressFcn', {@spacebar_callback});
        set(p.f1, 'KeyPressFcn', {@spacebar_callback});

    end
    p.InstructionHandle2= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction2, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    WhereUseris = sprintf('User: %d\nYou: %d',p.i, p.i2);
    WhereUseris = textwrap(p.InstructionHandle2, {WhereUseris});
    set(p.InstructionHandle2, 'String', WhereUseris, 'Visible', 'on');

end


function p = set_GUI_case13(p)
    set(p.ImageJohnSleeping, 'Visible','off')
    set(p.ImageArrow, 'Visible','off')
    instr_0 = '... hmm? ... ah ... i must have fallen asleep.\n\nHow are you holding up? Would you like a coffee?';
    instr = strrep(instr_0, '\n', sprintf('\n'));
    instr = textwrap(p.Text, {instr});
    set(p.Text, 'String', instr);
    set(p.ImageJohnYawning, 'Visible','on')
    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

end

function p = set_GUI_case14(p)
    set(p.ImageJohnHappy, 'Visible','off')
    set(p.ImageJohnYawning, 'Visible','off')
    set(p.ImageArrow, 'Visible','off')
    set(p.ImageArrow2, 'Visible','off')
    set(p.Text, 'Visible', 'off');
    set_progress_bar(p, p.f1, p.i, 'off', p.PosBar1)

    set(p.InstructionHandle1, 'String', 'Spacebar to proceed to next trial', 'Visible', 'on');        

    set(p.ImagePlay, 'Visible', 'on')
    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

end


function p = set_GUI_case25(p)
    set(p.ImageArrow2, 'Visible','off')
    set(p.ImageArrow, 'Visible','off')
    set(p.ImageVoice, 'Visible','off')    
    set(p.ImageJohnNeutral, 'Visible','off')
    set(p.ImageJohnIntro, 'Visible','off')
    set(p.Text, 'Visible', 'off');
    set(p.ImageSpeaker, 'Visible','on')
    set(p.InstructionHandle1, 'String', 'Playing..', 'Visible', 'on')

    p.InstructionHandle3= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction3, ...
    'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);  
    set(p.InstructionHandle3, 'String', 'Play', 'Visible', 'on');

    assignin('caller', 'User_Sitch', 26)
end


function p = set_GUI_case26(p)
    pause(0.1)
    set(p.ImageSpeaker, 'Visible','off');         
    set(p.InstructionHandle1, 'String', 'Please repeat')
    set(p.ImageVoice, 'Visible','on')      
    set(p.ImageAnswer, 'Visible','on')      

    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

    p.InstructionHandle3= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction3, ...
    'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);  
    set(p.InstructionHandle3, 'String', 'Repeat', 'Visible', 'on');

end

function p = set_GUI_case27(p)

    set(p.ImageVoice, 'Visible','off') 
    set(p.ImageAnswer, 'Visible','off') 
    set(p.InstructionHandle1,'Visible','off') 
    set(p.ImageReplay, 'Visible','on') 
    p.InstructionHandle3= uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction3, ...
    'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);  
    set(p.InstructionHandle3, 'String', 'Feedback', 'Visible', 'on');

    % buttons
    VU_index = sscanf(p.FileNames{p.i}, sprintf('%s%%03d', p.ManVrouw));

    switch p.ManVrouw
        case 'Man'
            sentence = p.VU_zinnen{VU_index};
        case 'Vrouw'
            sentence = p.VU_zinnen{VU_index+507};
    end

%     line_cell_cell=textscan(sentence,'%s',10,'delimiter',' ');
%     p.Words=line_cell_cell{1};
    p.Words = regexp(sentence, ' ', 'split');
    
    screenSub = getScreens;
    p.Spacing = (screenSub(3)/(length(p.Words))) - screenSub(3)/25;
    
    p.SentenceScore = ones(length(p.Words), 1);

    p.LengthWords = length(p.Words);
    for i2=1:length(p.Words)
        p.Instruction_user(i2) = uicontrol('Parent', p.f1, 'Style', 'text', 'Units', 'pixel', 'Position', ...
        [p.PosButtons_Small(1)+p.Spacing*(i2-1)-0.25*p.PosButtons_Small(3) p.PosButtons_Small(2)+1.25*p.PosButtons_Small(4) p.PosButtons_Small(3)*1.75 p.PosButtons_Small(4)*1.2], ...
        'FontSize', 14, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
        set(p.Instruction_user(i2), 'String', p.Words{i2})
    end

    set(p.f1, 'KeyPressFcn', {@spacebar_callback});
    set(p.f2, 'KeyPressFcn', {@spacebar_callback});

end

function p = set_GUI_case28(p)

    for ii=1:p.LengthWords
        set(p.Instruction_user(ii), 'Visible', 'off')
    end
    set(p.ImageReplay, 'Visible','off')

    if p.i <= p.TotalSampleLength    
        assignin('caller', 'User_Sitch', 25)
        set(p.ImageArrow, 'Visible', 'off')
        p.AnnotationsAvailable(end+1) = p.i;

    else
        p = set_progress_bar(p, p.f1, p.i, 'off', p.PosBar1);
        set(p.ImageVoice, 'Visible','off')      
        set(p.ImageArrow, 'Visible','off')  
        set(p.InstructionHandle1, 'Visible', 'off')
        switch p.Phase
            case 'Training1'
                instr_0 = 'Congradulations!\n\nYou can now proceed to the experiment.';
                set(p.ImageJohnHappy, 'Visible','on')
            case 'Training2'
                instr_0 = 'Well done! \n\nYou are now ready to proceeed to Trial #2.';
                set(p.ImageJohnHappy, 'Visible','on')
        end
        instr = strrep(instr_0, '\n', sprintf('\n'));
        instr = textwrap(p.Text, {instr});
        set(p.Text, 'String', instr, 'Visible', 'on');
        set(p.ImageArrow2, 'Visible','on')

        set(p.f2, 'KeyPressFcn', {@spacebar_callback});
        set(p.f1, 'KeyPressFcn', {@spacebar_callback});

        assignin('caller', 'User_Sitch', 0) 
        p.Continu = 0;
        p.current_situation=28;

    end
end



function p = set_GUI_saved(p)
    set(p.ImagePlay, 'Visible','on')
    set(p.InstructionHandle1, 'Visible','on', 'String', 'Press spacebar to resume experiment')
    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});

end

function spacebar_callback(~, event)
    if strcmp(event.Character, ' ')==1
        assignin('caller', 'pressed', 1) 
    end
    if strcmp(event.Character, '1')==1
        assignin('caller', 'waaaaaaaait', 1) 
    end
    if strcmp(event.Character, '2')==1
        assignin('caller', 'waaaaaaaait', 0) 
    end
end


function p = set_progress_bar(p, handle, index, onoff, PosBar)

    p.delaybar1 = axes('Parent', handle, 'Units', 'pixel','Position', PosBar, 'XTick', [], 'YTick', []);
    axes(p.delaybar1)

    switch p.Phase
        case {'Training1', 'Training2'}
            fill([0 1 1 0] * index/(p.TotalSampleLength), [0 0 1 1], 'g', 'EdgeColor','g');
        case 'Test1'
            fill([0 1 1 0] * index/(p.TotalSampleLength*2), [0 0 1 1], 'g', 'EdgeColor','g');
        case 'Test2'
            fill([0 1 1 0] * (index+p.TotalSampleLength)/(p.TotalSampleLength*4), [0 0 1 1], 'g', 'EdgeColor','g');
        case 'Test3'
            fill([0 1 1 0] * (index+p.TotalSampleLength)/(p.TotalSampleLength*2), [0 0 1 1], 'g', 'EdgeColor','g');
        case 'Test4'
            fill([0 1 1 0] * (index+p.TotalSampleLength*3)/(p.TotalSampleLength*4), [0 0 1 1], 'g', 'EdgeColor','g');
    end

    set(p.delaybar1, 'XColor', 'w', 'YColor', 'w', 'XTick', [], 'YTick', [], 'Xlim', [0 1], 'YLim', [0 1]);
    p.delaybarLegend1 = uicontrol('Parent', handle, 'Style', 'text', 'Units', 'pixel', 'Position', [PosBar(1) PosBar(2)-PosBar(4) PosBar(3) PosBar(4)], ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    set(p.delaybarLegend1, 'String', p.Phase(1:end-1), 'Visible', onoff)
    set(p.delaybar1, 'Visible', onoff)
end


%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%% %%% Preprocessing %%% %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% 




function p = make_file_names(p)
%     p.FileNames = cell(0);
%     p.FileNames_indexed = cell(0);
    p.FileNames = [];
    p.FileNames_indexed = [];

    [f0_len, vtl_len, snr_len] = size(p.ConditionsNames);

    f0_values = randperm(f0_len);
    vtl_values = randperm(vtl_len);

    for f0 = 1:f0_len
        for vtl=1:vtl_len
            for snr=1:snr_len
                for n=1:p.SamplesPerCondition
%                     p.FileNames{end+1} = sprintf('%s%03d%s%d%s%.2f%s%d', p.ManVrouw, ...
%                         n+ p.IndexStartingPoint-1 + (snr-1)*p.SamplesPerCondition + ...
%                         (vtl-1)*snr_len*p.SamplesPerCondition + (f0-1)*vtl_len*snr_len*p.SamplesPerCondition, ...
%                         '_f0', p.Conditions.f0(f0_values(f0)), '_vtl', p.Conditions.vtl(vtl_values(vtl)), '_snr', p.Conditions.snr(snr));
%                     p.FileNames_indexed{end+1} = sprintf('%s%03d%s%d%s%d%s%d', p.ManVrouw, ...
%                         n +p.IndexStartingPoint-1+ (snr-1)*p.SamplesPerCondition + ...
%                         (vtl-1)*snr_len*p.SamplesPerCondition + (f0-1)*vtl_len*snr_len*p.SamplesPerCondition, ...
%                         '_f0', f0_values(f0), '_vtl', vtl_values(vtl), '_snr', snr);
                    p.FileNames = [p.FileNames, {sprintf('%s%03d%s%d%s%.2f%s%d', p.ManVrouw, ...
                        n+ p.IndexStartingPoint-1 + (snr-1)*p.SamplesPerCondition + ...
                        (vtl-1)*snr_len*p.SamplesPerCondition + (f0-1)*vtl_len*snr_len*p.SamplesPerCondition, ...
                        '_f0', p.Conditions.f0(f0_values(f0)), '_vtl', p.Conditions.vtl(vtl_values(vtl)), '_snr', p.Conditions.snr(snr))}];
                    p.FileNames_indexed = [p.FileNames_indexed {sprintf('%s%03d%s%d%s%d%s%d', p.ManVrouw, ...
                        n +p.IndexStartingPoint-1+ (snr-1)*p.SamplesPerCondition + ...
                        (vtl-1)*snr_len*p.SamplesPerCondition + (f0-1)*vtl_len*snr_len*p.SamplesPerCondition, ...
                        '_f0', f0_values(f0), '_vtl', vtl_values(vtl), '_snr', snr)}];
                end
            end
        end
    end

    random_list = randperm(length(p.FileNames));
    p.FileNames=p.FileNames(random_list);
    p.FileNames_indexed = p.FileNames_indexed(random_list);
    p.TotalSampleLength = length(p.FileNames);

end




function p = initialize_saved(p)
    
    p.i = p.i2;
    p.AnnotationsAvailable = p.i;
    assignin('caller', 'User_Sitch',  20)
    assignin('caller', 'User2_Sitch',  [1 0])
    if p.i2 == 1
        clear all
        close all
        save('backup.mat')
        error('Restart experiment')
    end
end

function [case_out, p] = get_user_sitch(p, current_sitch)

%Tells the program where the GUI should go next based on where it currently is, and hence takes the current situation as a parameter. 
%In some cases, such as case 4, additional requirements are needed before the user can go to the next step in the GUI. 
%When a sound is being played, for example, you don?t want the user to go the the next screen until it?s finished. 

    switch current_sitch
        case 1
            switch p.Phase
                case 'Training1'
                    case_out = 2;
                case 'Training2'
                    case_out = 3;
                case {'Test1', 'Test2', 'Test3', 'Test4'}
                    case_out = 10;
            end
        case 2
            case_out = 3;
        case 3
            case_out = 4;
        case 4
            if strcmp(p.Player.Running, 'off')==1
                case_out = 25;
            else
                case_out = 0;
            end
        case 10
            case_out = 11;
        case 11
            case_out = 12;
        case 12
            if p.i <= p.TotalSampleLength
                case_out = 10;
            else
                switch p.Phase
                    case 'Test1'
                        case_out = 13;
                    case {'Training1', 'Training2'}
                        case_out = 14;
                    case {'Test2', 'Test3', 'Test4'}
                        case_out = 15;
                end
            end
        case 13
            case_out = 14;
        case 14
            case_out = 15;
        case 15
            set(p.ImageJohnHappy, 'Visible', 'off')
            case_out = 0;
        case 20
            case_out = 10;
        case 25
            case_out = 26;     
        case 26
            case_out = 29;
        case 27
            if strcmp(p.Player.Running, 'off')==1
                case_out = 28;
            else
                case_out = 0;
            end
          case 28
             case_out = 0;
             set(p.ImageJohnHappy, 'Visible', 'off')
             set(p.Text, 'Visible', 'off');
             set(p.ImageArrow2, 'Visible', 'off')
        case 29
            case_out = 27;

    end
    p.current_sitch = case_out;
end



