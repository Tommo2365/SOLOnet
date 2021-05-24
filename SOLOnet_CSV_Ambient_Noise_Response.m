%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%      Project:        SOLOnet SN51 7001 0329

%%%%%%      Auther:         T M F Hutchinson

%%%%%%      Version:        Issue 3

%%%%%%      Date:           25/03/2021

%%%%%%      Description:    Plot maker for fequently conducted experiemnts

%%%%%%      Comments:       Expects .csv files only. File must be in
%%%%%%                      C:\Users\"username"\Documents\MATLAB or similar root file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%*****************************************************************************%



% get file
matArray = csvread(uigetfile);

% Change this value to increase or decreas y-axis for response time   
yAxisAdjust = 10; % adjust integer to see more of y axis


% prompt box
prompt = {'Name of experment: Noise/Response/Ambient'};
dlgtitle = 'Input Vaule';
bootInput = inputdlg(prompt); % input
pltName = string(bootInput{1}); % convert eleemnt 2 into string



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  NOISE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if pltName == 'Noise' || pltName == 'n' || pltName == 'noise'
    
    prompt = {'Serial number:', 'Enter furnace set point Temperature:', 'Length of Experiment: (Time [s])'};
    dlgtitle = string(pltName);
    bootInput = inputdlg(prompt); % input
    SN = string(bootInput{1}); % serial number for save file name
    tempValue = string(bootInput{2}); % convert element 2 into string (number)
    lengthTime = (bootInput(3));
    
    pltName = 'Noise'
    % declae array
    % n = fscanf(inFile,formatSpec); % use for txt files
    yArray = matArray(:, 1);
    L = length(yArray);
    xArray = [1:1:L].';
    
    % create a time axis 
    timeSec = str2double(lengthTime)./L;
    xTime = xArray.*timeSec;
    
    % show standard deviation in command window
    stdDev = num2str(std(yArray));

    % settiing parameters for axis
    xMaxVal = max(xTime);
    %xMinVal = min(xArray);

    yMaxVal = max(yArray);
    yMinVal = min(yArray);

    yMaxPara = yMaxVal + 1;
    yMinPara = yMinVal - 1;

    % flip y-axis data upside down
    yAxis = flipud(yArray);
   
    % save file as xlsx
    A = [xTime, yAxis];

    fileName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), pltName,'_', tempValue,'C_' ,SN, '.xlsx');
    xlswrite(fileName, A);
    
    % make a plot
    nFig = figure; 
    scatter(xTime, yAxis);
    grid on;
    title([pltName,'at',tempValue,'ºC']);
    xlabel('Time [{\it s}]');
    ylabel('SOLOnet Temperature Reading [{\it ºC}]');
    %legend('StdDev:', stdDev);
    xlim([0 xMaxVal + 1]);
    ylim([yMinPara yMaxPara])
    
    % add text to plot
    annotation(nFig,'textbox',...
        [0.850852466225819 0.197951711165462 0.0878477282003988 0.138248844263924],...
        'String',{'StdDev:', stdDev},...
        'FitBoxToText','on',...
        'FontWeight','bold',...
        'FontSize',9);

    % y - axis conditions for Noise
    ylim([yMinPara yMaxPara]); % else use these parameters
 
    % write file name a savefig
    figName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), pltName,'_', tempValue,'C_' ,SN, '.fig');
    savefig(figName)
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  RESPONSE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



elseif pltName == 'Response' || pltName == 'r' || pltName == 'response'
    pltName = 'Response'
    
    prompt = {'Serial number:', 'Enter furnace set point Temperature:', 'Length of Experiment: (Time [s])'};
    dlgtitle = string(pltName);
    bootInput = inputdlg(prompt); % input
    SN = string(bootInput{1}); % serial number for save file name
    tempValue = string(bootInput{2}); % convert element 2 into string (number)
    lengthTime = (bootInput(3));
    
    % declae array
    %n = fscanf(inFile,formatSpec); % use for txt files
    yArray = matArray(:, 1);
    L = length(yArray);
    xArray = [1:1:L].';
    
    % create a time axis 
    timeSec = str2double(lengthTime)./L;
    xTime = xArray.*timeSec;
    
    % Find 90% of most common value
    mode = mode(yArray)
    percentile = mode*0.9
    
    % Find start of rise
   
    [minValues, idx] = mink(yArray,50);      %find lowest values
    rise = minValues(8:22);                  %from last lowest value, counting forwards, make new array of length 15 
    xRise = xTime(1:15);                     %time axis
   
    
    % show standard deviation in command window
    stdDev = std(yArray);
    
    % settiing parameters for axis
    xMaxVal = max(xArray);
    xMinVal = min(xArray);

    yMaxVal = max(yArray);
    yMinVal = min(yArray);

    yMaxPara = yMaxVal + 1;
    yMinPara = yMinVal - 1;

    yMedVal = median(yArray) - yAxisAdjust; % adjust integer to see more of y axis

    % save file as xlsx

    % flip y-axis data upside down
    yAxis = flipud(yArray);

    A = [xTime, yAxis];

    %pltName == 'Response'
    fileName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), pltName,'_', SN, '.xlsx');
    xlswrite(fileName, A);
   
    % full plot to check next plot is zoomed in at sutibale location (y - axis)
    rFig1 = subplot(1,2,1);
    scatter(xTime, yAxis);
    grid on;
    title([pltName,' at ', tempValue, 'ºC']);
    xlabel('Time [{\it s}]');
    ylabel('Signal [{\it ºC}]');
    %%legend('StdDev:', num2str(stdDev));
    %xlim([0 120]);
    
    % make a plot
    rFig2 = subplot(1,2,2);
    scatter(xRise, rise);
    grid on;
    title([pltName,' at ',tempValue,'ºC']);
    xlabel('Time [{\it s}]');
    ylabel('SOLOnet Temperature Reading [{\it ºC}]');
    %xlim([0 120]);
    %%ylim([550 yMaxPara]);  % use median to find approriate axis
    
    % write file name a savefig
    figName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), pltName,'_', SN, '.fig');
    savefig(figName)
    
    %saveas(fig1,figName,'.jpg' ,jpg)
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  AMBIENT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



elseif pltName == 'Ambient' || pltName == 'a' || pltName == 'ambient'
    prompt = {'Enter furnace temperature(Cyclops):', 'Number of steps:', 'Serial number: ', 'Apply offset (Y/N)?'};
    pltName = 'Ambient'
    
    dlgtitle = 'Input Vaule';
    input = inputdlg(prompt);      % input
    tempValue = str2num(input{1}); % convert element 'N' into number
    stepCount = str2num(input{2});
    SN = input{3};                 % for use in save file name     
    applyOffset = string(input(4)); % offset data to start at zero
    
    % declare array (:, axis number)
    xAxis = matArray(:, 1);
    yAxis = matArray(:, 2);
    
    % set up condtions
    xSum = sum(xAxis);
    ySum = sum(yAxis);

    % create a time axis 
    mins2secs = 60;
    %timeSec = str2double(lengthTime)./L);
    %xTime = xArray.*timeSec.*mins2secs;
    
    % swap columns if conditions are met to ensure consistant posstions
    if (xSum > ySum)
        yAxis = matArray(:, 1);
        xAxis = matArray(:, 2);
    end

    % subtract furnTemp from yAxis 
    %if yAxis == matArray(:, 1);
        %Error = yAxis - tempValue;
    %elseif xAxis == matArray(:, 1);
        %Error = yAxis - tempValue;
    %end
    
    % Data axis
    x = flipud(xAxis);
    yn = flipud(yAxis);
    %y = flipud(Error);

    % flip columns upsided down (data input is formated upside down prior)
    if stepCount >= 2;
        x = flipud(xAxis);
        yn =flipud(yAxis);
        %y = flipud(Error);
    end
   
    % make an offset so y-data starts at zero
    offsetVal = yn(1,1);
    
    if applyOffset == 'Y' || applyOffset == 'y' || applyOffset == '1';
        yn = yn - offsetVal;
    elseif applyOffset == 'N' || applyOffset == 'n' || applyOffset == '0';
        yn = yn;
    end
    
    % Find the maximum drift
    driftError = max(yn)-min(yn)
    driftError2 = num2str(driftError);

    % combine matrix axis
    A = [x,yn];     % edit [x,yn,y]
    
    % write file names and save data as xlsx
    if stepCount >= 2
        Filename = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), 'Ambient_STEP_', SN, '.xlsx' );
        xlswrite(Filename, A);
    elseif stepCount < 2
        Filename = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), 'Ambient_', SN, '.xlsx' );
        xlswrite(Filename, A);
    end

    % write file names and save plt as .fig
    if stepCount >= 2
        figName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), 'Ambient_STEP_', SN, '.fig');
    elseif stepCount < 2
        figName = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), 'Ambient_', SN, '.fig');
    end

    L = length(A);
    %sixty = [60::L].';
    time = [1/60:1/60:L/60].';
    
    % plot data
    aFig1 = subplot(2,1,1);
    scatter(x, yn);
    grid on;
    hold on
    if applyOffset == 'Y' || applyOffset == 'y';
        e1 = plot([5 50], [3 -7], 'LineWidth',2);
        e1.Color = 'r';
        hold on
        e2 = plot([5 50], [-3 7], 'LineWidth',2);
        e2.Color = 'r';
    end
    legend1 = legend('Drift','Spec','Spec');
    set(legend1,'Position',[0.85362164058084 0.505700114698771 0.127009644960667 0.119638822955956]);
    title('Ambient Response');
    xlabel('Detector Temperature [{\it ºC}]');
    ylabel('Offset Signal [{\it ºC}]' );
    
   
    % sub plot vs time
    aFig2 = subplot(2,1,2);
    yyaxis left
    scatter(time, yn);
    grid on;
    xlabel('Time [{\it mins}]');
    ylabel('Signal [{\it ºC}]' );
    hold on;
    yyaxis right
    plot(time, x);
    ylabel('Detector Temperature [{\it ºC}[');
    
 % add text to plot
    %annotation(aFig1,'textbox',...
        %[0.850852466225819 0.197951711165462 0.0878477282003988 0.138248844263924],...
        %'String',{'Number of steps:',(input{2}), '', 'Max Drift Error / {\it ºC}:',driftError2},...
        %'FitBoxToText','on',...
        %'FontWeight','bold',...
        %'FontSize',9);
    

    savefig(figName);
    
    %figPGN = sprintf( '%s', datestr(now,'yyyymmdd_HH_MM_SS_'), 'Ambient_', SN, '.pgn');
    
    %save(fileName)

end