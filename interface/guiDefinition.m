function p = guiDefinition(p, options)

    [screenSub, screenExp] = getScreens;
    
    widthSubScrn = screenSub(3);
    widthExpScreen = screenExp(3);
    heightSubScrn =  screenSub(4);
    heightBigExpScreen = screenExp(4);

    p.BackgroundColor = [.4 .4 .4];
    p.MainTextColor = [1 1 1]*.9;
    p.ProgressbarColor = [.5 .8 .5];

    p.f1=figure('Position', screenSub, 'Menubar', 'none', 'Resize', 'off', 'Color', p.BackgroundColor);
    p.f2=figure('Position', screenExp, 'Menubar', 'none', 'Resize', 'off', 'Color', p.BackgroundColor);
    
    p.PosCenter = [widthSubScrn/2.25, heightSubScrn/2, widthSubScrn/12, heightSubScrn/10];
    p.PosBottom = [widthSubScrn/2.2, heightSubScrn/6, widthSubScrn/16, heightSubScrn/16];


    p.PosRight = [widthSubScrn/4 + widthSubScrn/2.5 + widthSubScrn/10, heightSubScrn/2.5, widthSubScrn/16, heightSubScrn/16];
    p.PosJohn = [widthSubScrn/4 - widthSubScrn/10 heightSubScrn/6, widthSubScrn/10, heightSubScrn/2];
    p.PosText = [widthSubScrn/4, heightSubScrn/6, widthSubScrn/2.5 heightSubScrn/2];
    p.PosInstruction1 = [widthSubScrn/2.5, heightSubScrn/15 + heightSubScrn/8+heightSubScrn/2, widthSubScrn/12 + widthSubScrn/10, heightSubScrn/15];
    p.PosBar1 = [widthSubScrn/2 - (widthSubScrn/3)/2,  heightSubScrn-heightSubScrn/16, widthSubScrn/3, heightSubScrn/16];
    p.PosInstruction5 = [widthSubScrn/16, heightSubScrn/1.5 + heightSubScrn/16, widthSubScrn/8, heightSubScrn/4];


    p.PosBar2 = [widthExpScreen/2-(widthExpScreen/3)/2,  heightBigExpScreen-heightBigExpScreen/16, widthExpScreen/3, heightBigExpScreen/16];
    p.PosButtons = [widthExpScreen/16 heightBigExpScreen/2.5 widthExpScreen/25 widthExpScreen/25];
    p.PosButtons_Small = [widthSubScrn/16 heightSubScrn/2.5 widthSubScrn/25 widthSubScrn/25];
    p.PosBottom2 = [widthExpScreen/2-(widthExpScreen/16)/2, heightBigExpScreen/7.5, widthExpScreen/16, heightBigExpScreen/16];
    p.PosInstruction2 = [widthExpScreen/4+widthExpScreen/2.5+widthExpScreen/10, heightBigExpScreen/1.5, widthExpScreen/16, heightBigExpScreen/16];
    p.PosInstruction3 = [widthExpScreen/4+widthExpScreen/2.5+widthExpScreen/10, heightBigExpScreen/1.5+heightBigExpScreen/16, widthExpScreen/16, heightBigExpScreen/16];
    p.PosInstruction4 = [widthExpScreen/16, heightBigExpScreen/1.5+heightBigExpScreen/16, widthExpScreen/12, heightBigExpScreen/8];

    p.PosPause1 = [widthSubScrn/2-widthSubScrn/12, heightSubScrn/1.5+heightSubScrn/16, widthSubScrn/8, heightSubScrn/16];
    p.PosPause2 = [widthExpScreen/2-widthExpScreen/12, heightBigExpScreen/1.5+heightBigExpScreen/16, widthExpScreen/12, heightBigExpScreen/16];


    % user figures
    im_play=imread([options.imagesDir 'play.jpg']);
    play_axes_handel = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosCenter, 'XTick', [], 'YTick', []);
    axes(play_axes_handel)
    p.ImagePlay=image(im_play);
    set(p.ImagePlay, 'Visible','off')
    set(play_axes_handel, 'Visible','off')

    im_speaker=imread([options.imagesDir 'speaker.jpg']);
    speaker_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosCenter, 'XTick', [], 'YTick', []);
    axes(speaker_image_axes_handle)
    p.ImageSpeaker=image(im_speaker);
    set(p.ImageSpeaker, 'Visible','off')
    set(speaker_image_axes_handle, 'Visible','off')

    im_voice=imread([options.imagesDir 'voice.jpg']);
    voice_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosCenter, 'XTick', [], 'YTick', []);
    axes(voice_image_axes_handle)
    p.ImageVoice=image(im_voice);
    set(p.ImageVoice, 'Visible','off')
    set(voice_image_axes_handle, 'Visible','off')

    im_arrow=imread([options.imagesDir 'continue_arrow.jpg']);
    arrow_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosBottom, 'XTick', [], 'YTick', []);
    axes(arrow_image_axes_handle)
    p.ImageArrow=image(im_arrow);
    set(p.ImageArrow, 'Visible','off')
    set(arrow_image_axes_handle, 'Visible','off')

    p.Text = uicontrol('Parent', p.f1, 'Style', 'text', 'Position', p.PosText, 'Fontsize', 16, 'HorizontalAlignment', 'left', 'BackgroundColor', [1 1 1], 'Visible', 'off');

    im_arrow2=imread([options.imagesDir 'continue_arrow.jpg']);
    arrow_image_axes_handle2 = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosRight, 'XTick', [], 'YTick', []);
    axes(arrow_image_axes_handle2)
    p.ImageArrow2=image(im_arrow2);
    set(p.ImageArrow2, 'Visible','off')
    set(arrow_image_axes_handle2, 'Visible','off')

    john_intro=imread([options.imagesDir 'John_intro.jpg']);
    john_intro_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosJohn, 'XTick', [], 'YTick', []);
    axes(john_intro_image_axes_handle)
    p.ImageJohnIntro=image(john_intro);
    set(p.ImageJohnIntro, 'Visible','off')
    set(john_intro_image_axes_handle, 'Visible','off')

    john_sleeping=imread([options.imagesDir 'john_sleeping.jpg']);
    john_sleeping_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosJohn, 'XTick', [], 'YTick', []);
    axes(john_sleeping_image_axes_handle)
    p.ImageJohnSleeping=image(john_sleeping);
    set(p.ImageJohnSleeping, 'Visible','off')
    set(john_sleeping_image_axes_handle, 'Visible','off')

    john_happy=imread([options.imagesDir 'john_happy.jpg']);
    john_happy_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosJohn, 'XTick', [], 'YTick', []);
    axes(john_happy_image_axes_handle)
    p.ImageJohnHappy=image(john_happy);
    set(p.ImageJohnHappy, 'Visible','off')
    set(john_happy_image_axes_handle, 'Visible','off')

    john_neutral=imread([options.imagesDir 'john_neutral.jpg']);
    john_neutral_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosJohn, 'XTick', [], 'YTick', []);
    axes(john_neutral_image_axes_handle)
    p.ImageJohnNeutral=image(john_neutral);
    set(p.ImageJohnNeutral, 'Visible','off')
    set(john_neutral_image_axes_handle, 'Visible','off')

    john_yawning=imread([options.imagesDir 'john_yawning.jpg']);
    john_yawning_image_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosJohn, 'XTick', [], 'YTick', []);
    axes(john_yawning_image_axes_handle)
    p.ImageJohnYawning=image(john_yawning);
    set(p.ImageJohnYawning, 'Visible','off')
    set(john_yawning_image_axes_handle, 'Visible','off')

    answer=imread([options.imagesDir 'answer.JPG']);
    answer_axes_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosBottom, 'XTick', [], 'YTick', []);
    axes(answer_axes_handle)
    p.ImageAnswer=image(answer);
    set(p.ImageAnswer, 'Visible','off')
    set(answer_axes_handle, 'Visible','off')

    replay=imread([options.imagesDir 'replay.JPG']);
    replay_aces_handle = axes('Visible', 'off', 'Parent', p.f1, 'Units', 'pixel','Position', p.PosBottom, 'XTick', [], 'YTick', []);
    axes(replay_aces_handle)
    p.ImageReplay=image(replay);
    set(p.ImageReplay, 'Visible','off')
    set(replay_aces_handle, 'Visible','off')

    p.InstructionHandle1= uicontrol('Parent', p.f1, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosInstruction1, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);

    % user 2 figure preperation
    p.ImreadConfirm = imread([options.imagesDir 'confirm.jpg']);
    p.ImreadWrong = imread([options.imagesDir 'wrong.jpg']);
    p.ImreadRight = imread([options.imagesDir 'right.jpg']);

    % pause instruction
    p.InstructionHandle6 = uicontrol('Parent', p.f2, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosPause2, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);
    p.InstructionHandle7= uicontrol('Parent', p.f1, 'Style', 'text', 'Units', 'pixel', 'Position', p.PosPause1, ...
        'FontSize', 20, 'ForegroundColor', p.MainTextColor, 'BackgroundColor', p.BackgroundColor);

    % initialize spacebar callback
    set(p.f2, 'KeyPressFcn', {@spacebar_callback});
    set(p.f1, 'KeyPressFcn', {@spacebar_callback});
    
end