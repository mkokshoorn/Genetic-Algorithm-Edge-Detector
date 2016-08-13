function gen_main ()
    global popSize;
    global generations;
    global breedNum;
    global surviveNum;
    global noises;
    global noiseWeights;
    global totCount;
    global mutateGains;

    % --------------------------------------------------------------------
    %       Variables / Initialisation
    % --------------------------------------------------------------------
    
    % GUI and corresponding data struct.
    GUI_figure = figure('Position', [10 10 1000*500/563 1000]);
    shareData = guidata(GUI_figure);
    
    % Population information.
    generations = 10;
    popSize = 10;

    geneCap = 0.5;
    survivalCap = 0.1;
    breedNum = floor(popSize*geneCap);
    surviveNum = floor(popSize*survivalCap);
    
    mutateGains = [0.3, 25, 0.1, 3, 1];

    % Noise information.
    noises = [0.05, 0.1];
    noiseWeights = [0, 1, 1];

    % Identify images for training.
    initImgStruct(GUI_figure);
    
    % Initialise the training and noise images.
    initialiseImages(GUI_figure);
    shareData = guidata(GUI_figure);
    
    % Values for GUI image locations
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    
    % Create EdgeDetector Object Array
    obj(1, popSize) = EdgeDetector();
    obj(1, popSize).mutateGains=mutateGains;
    shareData.obj=obj;
    totCount=1;
    
    % --------------------------------------------------------------------
    %       GUI / Handlers
    % --------------------------------------------------------------------
    
    % Text: Status
    updateStatusText('Ready');
    
    % Text: Mutation Gains
    updateMGain1Text();
    updateMGain2Text();
    updateMGain3Text();
    updateMGain4Text();
    
    % Slider: Mutation Gains
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0.01,'Max',0.5,'Value',mutateGains(1),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+15/20 7/10 1/20]*positionBase,...
        'Callback', {@updateMGain1Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',1,'Max',50,'Value',mutateGains(2),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+14/20 7/10 1/20]*positionBase,...
        'Callback', {@updateMGain2Slider, GUI_figure});

    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0.1,'Max',10,'Value',mutateGains(3),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+13/20 7/10 1/20]*positionBase,...
        'Callback', {@updateMGain3Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0.2,'Max',20,'Value',mutateGains(4),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+12/20 7/10 1/20]*positionBase,...
        'Callback', {@updateMGain4Slider, GUI_figure});
    
    % Text: Noise
    updateNGain0Text();
    updateNoise1Text();
    updateNGain1Text();
    updateNoise2Text();
    updateNGain2Text();
    
    % Slider: Noise
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0,'Max',1,'Value',noiseWeights(1),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+11/20 7/10 1/20]*positionBase,...
        'Callback', {@updateNGain0Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0,'Max',1,'Value',noises(1),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+10/20 7/10 1/20]*positionBase,...
        'Callback', {@updateNoise1Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0,'Max',1,'Value',noiseWeights(2),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+9/20 7/10 1/20]*positionBase,...
        'Callback', {@updateNGain1Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0,'Max',1,'Value',noises(2),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+8/20 7/10 1/20]*positionBase,...
        'Callback', {@updateNoise2Slider, GUI_figure});
    
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',0,'Max',1,'Value',noiseWeights(3),...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+7/20 7/10 1/20]*positionBase,...
        'Callback', {@updateNGain2Slider, GUI_figure});
    
    % Text: Generations
    updateGenerationsText();
    
    % Slider: Generations
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',1,'Max',5000,'Value',generations,...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+17/20 7/10 1/20]*positionBase,...
        'Callback', {@updateGenerationsSlider});
    
    % Text: Population Size
    updatePopSizeText();
    
    % Slider: Population Size
    uicontrol('Style', 'slider',...
        'Units', 'normalized',...
        'Min',1,'Max',2000,'Value',popSize,...
        'Position', [(imageNum-1)+3/10 (imageNum-1)+16/20 7/10 1/20]*positionBase,...
        'Callback', {@updatePopSizeSlider});
    
    % Button: Start
    uicontrol('Style', 'pushbutton', 'String', 'Start',...
        'Units', 'normalized',...
        'Position', [(imageNum-1) (imageNum-1)+9/10 5/10 1/10]*positionBase,...
        'Callback', {@resetPopulation, GUI_figure});
    
    % Button: Continue
    uicontrol('Style', 'pushbutton', 'String', 'Continue',...
        'Units', 'normalized',...
        'Position', [(imageNum-1)+5/10 (imageNum-1)+9/10 5/10 1/10]*positionBase,...
        'Callback', {@mainLoop, GUI_figure});
    
    % Images: Original Images and Labels
    setNoiseImages(GUI_figure);
    
    % Update GUI Data Struct
    guidata(GUI_figure, shareData);
end

% --------------------------------------------------------------------
%       GUI / Functions
% --------------------------------------------------------------------

function updateStatusText(inText)
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1) 1 1/20]*positionBase,...
        'String',inText);
end

function updateStatus2Text(inText)
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+1/20 1 1/20]*positionBase,...
        'String',inText);
end

function updateMGain1Slider(hObj,event,GUI_figure)
    global mutateGains;
    val=get(hObj,'Value');
    mutateGains(1)=val;
    updateMGain1Text();
    updateMGainsAll(GUI_figure);
end

function updateMGain2Slider(hObj,event,GUI_figure)
    global mutateGains;
    val=get(hObj,'Value');
    mutateGains(2)=val;
    updateMGain2Text();
    updateMGainsAll(GUI_figure);
end

function updateMGain3Slider(hObj,event,GUI_figure)
    global mutateGains;
    val=get(hObj,'Value');
    mutateGains(3)=val;
    updateMGain3Text();
    updateMGainsAll(GUI_figure);
end

function updateMGain4Slider(hObj,event,GUI_figure)
    global mutateGains;
    val=get(hObj,'Value');
    mutateGains(4)=val;
    updateMGain4Text();
    updateMGainsAll(GUI_figure);
end

function updateMGainsAll(GUI_figure)
    global mutateGains;
    global popSize;
    shareData = guidata(GUI_figure);
    for I=1:popSize
        shareData.obj(1, I).mutateGains=mutateGains;
    end
    guidata(GUI_figure, shareData);
end

function updateMGain1Text()
    global noises;
    global mutateGains;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+15/20 3/10 1/20]*positionBase,...
        'String',['Matrix Mutate Gain: ',num2str(mutateGains(1),2)]);
end

function updateMGain2Text()
    global noises;
    global mutateGains;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+14/20 3/10 1/20]*positionBase,...
        'String',['Threshold Mutate Gain: ',int2str(mutateGains(2))]);
end

function updateMGain3Text()
    global noises;
    global mutateGains;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+13/20 3/10 1/20]*positionBase,...
        'String',['Thinning Mutate Gain: ',num2str(mutateGains(3),2)]);
end

function updateMGain4Text()
    global noises;
    global mutateGains;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+12/20 3/10 1/20]*positionBase,...
        'String',['Size Mutate Gain: ',num2str(mutateGains(4),2)]);
end

function updateNGain0Slider(hObj,event,GUI_figure)
    global noiseWeights;
    val=get(hObj,'Value');
    noiseWeights(1)=val;
    updateNGain0Text();
end

function updateNGain0Text()
    global noises;
    global noiseWeights;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+11/20 3/10 1/20]*positionBase,...
        'String',['Base Noise Gain: ',num2str(noiseWeights(1),2)]);
end

function updateNoise1Slider(hObj,event,GUI_figure)
    global noises;
    val=get(hObj,'Value');
    noises(1)=val;
    updateNoise1Text();
    initialiseImages(GUI_figure);
    
    setNoiseImages(GUI_figure);
end

function updateNoise1Text()
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+10/20 3/10 1/20]*positionBase,...
        'String',['Noise 1 Amount: ',num2str(noises(1),2)]);
end

function updateNGain1Slider(hObj,event,GUI_figure)
    global noiseWeights;
    val=get(hObj,'Value');
    noiseWeights(2)=val;
    updateNGain1Text();
end

function updateNGain1Text()
    global noises;
    global noiseWeights;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+9/20 3/10 1/20]*positionBase,...
        'String',['Noise Gain 1: ',num2str(noiseWeights(2),2)]);
end

function updateNoise2Slider(hObj,event,GUI_figure)
    global noises;
    
    val=get(hObj,'Value');
    noises(2)=val;
    updateNoise2Text();
    initialiseImages(GUI_figure);
    
    setNoiseImages(GUI_figure);
end

function updateNoise2Text()
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+8/20 3/10 1/20]*positionBase,...
        'String',['Noise 2 Amount: ',num2str(noises(2),2)]);
end

function setNoiseImages(GUI_figure)
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    shareData = guidata(GUI_figure);
    testImg = shareData.testImg;
    axes('Parent', GUI_figure,...
        'Units', 'normalized',...
        'Position',[0 1/2 1 1/2]*positionBase,...
        'Visible', 'off');
    imshow(imread(char(testImg.inImg)));
    for I = 1:length(noises)
        axes('Parent', GUI_figure,...
            'Units', 'normalized',...
            'Position',[(mod(I, imageNum)) floor((I)/imageNum)+1/2 1 1/2]*positionBase,...
            'Visible','off');
        imshow(imread(char(testImg.inNoise(I+1,:))));
    end
    text=uicontrol('Style','text',...
            'Units', 'normalized',...
            'Position',[3/7 19/20 1/7 1/20]*positionBase,...
            'String',strcat('Noise: 0%'));
    set(text,'BackGroundColor','red');
    for I = 1:imageNum
        text=uicontrol('Style','text',...
            'Units', 'normalized',...
            'Position',[(mod(I, imageNum))+3/7 floor((I)/imageNum)+19/20 1/7 1/20]*positionBase,...
            'String',['Noise: ', int2str(noises(I)*100), '%']);
        set(text,'BackGroundColor','red');
    end
    drawnow;
end

function updateNGain2Slider(hObj,event,GUI_figure)
    global noiseWeights;
    val=get(hObj,'Value');
    noiseWeights(3)=val;
    updateNGain2Text();
end

function updateNGain2Text()
    global noises;
    global noiseWeights;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+7/20 3/10 1/20]*positionBase,...
        'String',['Noise Gain 2: ',num2str(noiseWeights(3),2)]);
end

function updateGenerationsSlider(hObj,event)
    global generations;
    val=get(hObj,'Value');
    generations=round(val);
    updateGenerationsText();
end

function updateGenerationsText()
    global noises;
    global generations;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+17/20 3/10 1/20]*positionBase,...
        'String',['Generations: ',int2str(generations)]);
end

function updatePopSizeSlider(hObj, event)
    global popSize;
    val=get(hObj,'Value');
    popSize=round(val);
    updatePopSizeText();
end

function updatePopSizeText()
    global noises;
    global popSize;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uicontrol('Style','text',...
        'Units', 'normalized',...
        'Position',[(imageNum-1) (imageNum-1)+16/20 3/10 1/20]*positionBase,...
        'String',['Pop Size: ',int2str(popSize)]);
end

function updateBestMatrix(inMatrix)
    global noises;
    imageNum = ceil(sqrt((length(noises)+1)));
    positionBase = 1/imageNum;
    uitable('Units', 'normalized',...
        'Position', [(imageNum-1) (imageNum-1)+2/20 1 5/20]*positionBase,...
        'Data', inMatrix);
end

function initialiseImages(GUI_figure)
    global noises;
    
    shareData = guidata(GUI_figure);
    img = shareData.img;
    testImg = shareData.testImg;
    
    % Generate and write noise and training images.
    for I=1:length(noises)
        writeLocation=strcat(testImg.inNoise(1), int2str(I), '.png');
        testImg.inNoise(I+1,:)=writeLocation;
        for II=1:5
            writeLocation=strcat(img(II).inNoise(1), int2str(I), '.png');
            img(II).inNoise(I+1,:)=writeLocation;
        end
    end

    createNoiseImage(testImg, noises, 'gaussian');

    for i = 1:length(img)
        createNoiseImage(img(i), noises, 'gaussian');
        conditionIdealEdgeImage(img(i), 1);
    end
    shareData.testImg = testImg;
    shareData.img = img;
    guidata(GUI_figure, shareData);
end

function resetPopulation(hObj, event, GUI_figure)
    global noiseWeights;
    global popSize;
    global totCount;
    global mutateGains;
    
    updateStatusText('Processing ...');
    drawnow;

    % Initialise population
    shareData = guidata(GUI_figure);
    img = shareData.img;
    
    obj(1, popSize) = EdgeDetector();
    for i = 1:popSize
        obj(1,i) = EdgeDetector();
        obj(1,i).mutateGains=mutateGains;
        obj(1,i).convertToGene();
        obj(1,i).getFitness(img, noiseWeights);
    end
    
    shareData.obj=obj;
    guidata(GUI_figure, shareData)
    
    totCount = 0;
    mainLoop(hObj, event, GUI_figure)
end

function mainLoop(hObj, event, GUI_figure)
    global popSize;
    global generations;
    global breedNum;
    global surviveNum;
    global noises;
    global noiseWeights;
    global totCount;
    global mutateGains;
    
    shareData = guidata(GUI_figure);
    img = shareData.img;
    testImg = shareData.testImg;
    obj=shareData.obj;
    
    oldBest = obj(popSize:popSize);
    
    for loopCount = 1:generations
        totCount = totCount + 1;
        
        updateStatusText(['Processing ... ' int2str(loopCount) '/' int2str(generations) ' (Total: ' int2str(totCount) ')']);
    
        [~,idx]=sort([obj.fitness]);
        obj=obj(idx);
        
        survivors = obj(popSize-breedNum+1:popSize);

        imageNum = ceil(sqrt((length(noises)+1)));
        positionBase = 1/imageNum;

        if ~(isequal(oldBest.matrix,obj(popSize:popSize).matrix))||oldBest.threshold~=obj(popSize:popSize).threshold||oldBest.thinning~=obj(popSize:popSize).thinning||oldBest.median_value~=obj(popSize:popSize).median_value
            axes('Parent', GUI_figure, 'Units', 'normalized', 'Position',[0 0 1 1/2]*positionBase, 'Visible', 'off')
            detectEdges(imread(testImg.inImg),obj(1,popSize).matrix,obj(1,popSize).threshold,obj(1,popSize).thinning,obj(1,popSize).median_value,1,1,strcat('out/bestResult1.',int2str(totCount),'.png'));
            for I = 1:length(noises)
                axes('Parent', GUI_figure, 'Units', 'normalized', 'Position',[(mod(I, imageNum)) floor((I)/imageNum) 1 1/2]*positionBase)
                detectEdges(imread(char(testImg.inNoise(I+1,:))),obj(1,popSize).matrix,obj(1,popSize).threshold,obj(1,popSize).thinning,obj(1,popSize).median_value,1,1,strcat('out/bestResult',int2str(I+1),'.',int2str(totCount),'.png'));
            end
            updateBestMatrix(obj(popSize:popSize).matrix);
            updateStatus2Text(['Last updated for ' int2str(totCount) ...
                '. Current Fitness: ' ...
                num2str(obj(popSize:popSize).fitness,4) '  Threshold: ' ...
                int2str(obj(popSize:popSize).threshold) '  Thinning: '...
                num2str(obj(popSize:popSize).thinning,4) '.']);
        end
        drawnow;
        oldBest = obj(popSize:popSize);


        % MUTATIONS / BREEDING
        for i = 1:popSize-surviveNum
            obj(1,i)=EdgeDetector([survivors(1,floor(rand(1)*breedNum)+1).gene]);
            obj(1,i).mutateGains=mutateGains;
            obj(1,i).getMutations();
            breedEdgeDetectors(obj(1,i), survivors(1,floor(rand(1)*breedNum)+1));
            obj(1,i).convertFromGene();
            obj(1,i).updateSize();
        end

        % FITNESSES
        for i = 1:popSize
            obj(1,i).getFitness(img, noiseWeights);
        end
    end
    
    updateStatusText(['Ready (Total: ' int2str(totCount) ')']);
    shareData.obj=obj;
    guidata(GUI_figure, shareData);
end

function initImgStruct(GUI_figure)
    % Initialises the image information.
    % Images taken from http://homepages.inf.ed.ac.uk/rbf/HIPR2/canny.htm.
    shareData = guidata(GUI_figure);
    
    img = struct;
    testImg = struct;

    img(1).inImg = 'img/img1In.png';
    img(1).inNoise(1) = {'tempimg/im1n'};
    img(1).outImg = 'tempimg/im1.png';
    img(1).outImgIdeal = 'img/Img1OutIdeal.png';
    img(1).weighting = 1;

    img(2).inImg = 'img/img2In.png';
    img(2).inNoise(1) = {'tempimg/im2n'};
    img(2).outImg = 'tempimg/im2.png';
    img(2).outImgIdeal = 'img/Img2OutIdeal.png';
    img(2).weighting = 1;

    img(3).inImg = 'img/img3In.png';
    img(3).inNoise(1) = {'tempimg/im3n'};
    img(3).outImg = 'tempimg/im3.png';
    img(3).outImgIdeal = 'img/Img3OutIdeal.png';
    img(3).weighting = 1;

    img(4).inImg = 'img/img4In.png';
    img(4).inNoise(1) = {'tempimg/im4n'};
    img(4).outImg = 'tempimg/im4.png';
    img(4).outImgIdeal = 'img/Img4OutIdeal.png';
    img(4).weighting = 5;

    img(5).inImg = 'img/img5In.png';
    img(5).inNoise(1) = {'tempimg/im5n'};
    img(5).outImg = 'tempimg/im5.png';
    img(5).outImgIdeal = 'img/Img5OutIdeal.png';
    img(5).weighting = 1;

    testImg.inImg = 'BF3_StagingArea_GDC.jpg';
    testImg.inNoise(1) = {'tempimg/testn'};
    testImg.outImg = '';
    testImg.outImgIdeal = '';
    testImg.weighting = 1;
    
    shareData.img = img;
    shareData.testImg = testImg;
    guidata(GUI_figure, shareData);
end
