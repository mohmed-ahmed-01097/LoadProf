function []=LoadProf()
% Assiut University Master
% Flush 
clc;
clear;
% creat output folders
mkdir('Result');
mkdir('Plots');
mkdir('MatData');

%%
% Start the timer
startTime = tic;
Start_Time = datestr(now);

%%
% save Temperature Data
% loadprof_downloadTemp(longitude, latitude, year);
loadprof_downloadTemp  (  31.1752,  27.1888, 2023);

%%
% initialize input data
load('Prop_Struct.mat');

%https://power.larc.nasa.gov/data-access-viewer/
TempratureReads   = table2array(readtable('Temp_Read.csv'));
loadprof_saveplot( 1, 8760, 0, 50, 1, 2, mat2cell(TempratureReads(:, 5)', 1, 8760), '2M Temperature', 'Time(hr)', 'Temperature (C*)', {'2M Temp'}, '.\Result\TempratureReads.png');

percentageRange = [0.3, 0.5, 0.2]; % Percentage for each category

%%
clc;
disp('Generating Data for each device in each House per Hour...');
% Parameters
numHouses         = 10; % Number of households
numHours          = 24;   % Number of hours in a day
numDays           = 31;   % Number of days in a month
numMonths         = 12;   % Number of months in a year
numYearDays       = 365;  % Number of days in a year

classNum          = length(percentageRange);
applianceNum      = length(Prop_Struct.Name);
houresNum         = length(TempratureReads);
%%
% Generate Houses, and Devices data
[numFamilyMembers, applianceCounts, applianceUsages, houseClass, hourlyHouseUsages] = ...
    loadprof_GenerateData(numHouses, applianceNum, houresNum, percentageRange, Prop_Struct, TempratureReads);                                                                           % hourlyProbability, TempratureReads

%%
%clc;
disp('Generating Hourly usage of each class of houses ...');
% Init arrays
classUsages = zeros(classNum, houresNum);
classHousesNum = zeros(classNum, 1);
for i = 1:numHouses
    class = houseClass(i);
    classHousesNum(class) = classHousesNum(class) + 1;
    classHousesUsage(class, classHousesNum(class), :) = hourlyHouseUsages(i,:);
end
clear class;
for i = 1:classNum
    for j = 1:classHousesNum(i)
        %         retval        = loadprof_filterData(  width  ,        cutoff, order,         data                                    );
        classHousesUsage(i,j,:) = loadprof_filterData(houresNum,   houresNum/6,     2, reshape(classHousesUsage(i,j,:), [1, houresNum]));
    end
    classUsages(i,:) = reshape(sum(classHousesUsage(i,:,:)) / classHousesNum(i), [1, houresNum]);
end

%%
%clc;
disp('Generating Avrage Day Load Profile of each class of houses ...');
% Init arrays
class_ZRange    = [10000, 20000, 40000, 30000];
plotdays        = [1, 7, 30, 365];
linewidths      = [2, 1.5, 1.5, 1];

avgDayHoursLoadProfile = zeros(classNum, numHours);
DaysUsage              = zeros(houresNum/numHours, numHours);
DayHoursLoadProfile    = zeros(classNum, houresNum);

min_monthDaysUsage     = zeros(numMonths, numDays, numHours);
max_monthDaysUsage     = zeros(numMonths, numDays, numHours);

array = cell(4, classNum, length(plotdays)-1);  % Initialize your cell array

for i = 1:classNum
    % Get the index of max and min House Usage
    [val, idx_min] = min(sum(reshape(classHousesUsage(i,1:classHousesNum(i),:), [classHousesNum(i) houresNum]),2));
    [val, idx_max] = max(sum(reshape(classHousesUsage(i,1:classHousesNum(i),:), [classHousesNum(i) houresNum]),2));
    
        
    days = 1;
    for j = 1:houresNum
        if TempratureReads(j, 4) == 0
            days = days + 1;
        end
        if TempratureReads(j, 3) == 1 && TempratureReads(j, 2) == 1
            days = 1;
        end
        % split the data to array of days Hourly Usage
        DaysUsage(days, TempratureReads(j, 4) + 1) = classHousesUsage(i,idx_max,j);
        
        % split the data to array of Hourly Usage of Days of Months
        min_monthDaysUsage(TempratureReads(j, 2), TempratureReads(j, 3), TempratureReads(j, 4) + 1) = classHousesUsage(i,idx_min,j);
        max_monthDaysUsage(TempratureReads(j, 2), TempratureReads(j, 3), TempratureReads(j, 4) + 1) = classHousesUsage(i,idx_max,j);
    end
    clear days;
    clear val;
    clear idx_min;
    clear idx_max;
    
    %loadprof_saveSurf(X_min, X_max, Y_min, Y_max, Z_min,  Z_mx,      Data, Xlabel, Ylabel, Zlabel,     %fileSave                                              );
    loadprof_saveSurf   (    0,    (numHours-1),     1,  numYearDays,     0, class_ZRange(i), DaysUsage, 'Time(hr)', 'Days', 'Power(W)', strcat('.\Plots\class_', string(i),'_Days_loadProfile.png'));
    loadprof_saveSurfSub(    0,    (numHours-1),     1,  numYearDays,     0, class_ZRange(i), DaysUsage, 'Time(hr)', 'Days', 'Power(W)', strcat('.\Plots\1class_', string(i),'_Days_loadProfile.png'));

    for k = 1:numMonths
        %loadprof_saveSurf(X_min, X_max, Y_min, Y_max, Z_min,  Z_mx,      Data,     %fileSave                                              );
        loadprof_saveSurf (    0,    (numHours-1),     1,  numDays,     0, class_ZRange(i), reshape(max_monthDaysUsage(k,:,:), [numDays, numHours]), 'Time(hr)', 'Days', 'Power(W)', strcat('.\Plots\class_', string(i),'_Month', string(k),'Days_loadProfile.png'));
    end
    
    avgDayHoursLoadProfile(i, :) = reshape(sum(sum(max_monthDaysUsage)), [1,numHours])./numYearDays; 
    DayHoursLoadProfile(i,:) = reshape(DaysUsage', [1, houresNum]);

for j = 1:length(plotdays)-1
    array{1, i, j} = reshape(reshape(min_monthDaysUsage(1,1:plotdays(j), :), [plotdays(j),numHours])', [1,plotdays(j)*numHours]);
    array{2, i, j} = reshape(reshape(max_monthDaysUsage(1,1:plotdays(j), :), [plotdays(j),numHours])', [1,plotdays(j)*numHours]);
    array{3, i, j} = reshape(reshape(min_monthDaysUsage(7,1:plotdays(j), :), [plotdays(j),numHours])', [1,plotdays(j)*numHours]);
    array{4, i, j} = reshape(reshape(max_monthDaysUsage(7,1:plotdays(j), :), [plotdays(j),numHours])', [1,plotdays(j)*numHours]);
end
end
%%
%clc;
disp('Plot the Day Load Profile ...');
files = {'Days', 'Weeks', 'Months'};
for j = 1:length(plotdays)-1
    data = array(:, :, j);
    loadprof_saveplotsub(0    , plotdays(j)*numHours-1, 0, class_ZRange(3), 3, 2, ...         % X_min, X_max, Y_min,  Y_max, lineNum, lineWidth
    data, {'Min of January','Max of January','Min of July','Max of July'}, ...                % Data,
     'Time(hr)', 'Power (W)', ...                                                             % 
    {'Class A','Class B', 'Class C'}, strcat('.\Result\', string(files(j)), '.png'));         % legendNames, fileSave
    clear data;

end
%%
%clc;
disp('Plot the Avrage Day Load Profile ...');
loadprof_saveplot  ( 0, (numHours-1), 0, class_ZRange(4), classNum, ones(classNum)*5,...                % X_min, X_max, Y_min,  Y_max, lineNum, lineWidth
    mat2cell(avgDayHoursLoadProfile, ones(1, classNum), numHours), ...                                  % Data
    'Avrage Day Load Profile', 'Time(hr)', 'Power (W)', ...                                             % 
    {'Class A','Class B', 'Class C'}, '.\Result\AvrageDayloadProfile.png');                             % legendNames, fileSave

%%
%clc;
disp('Plot the Avrage Day Load Profile ...');
loadprof_saveplot  ( 0, (houresNum-1), 0, class_ZRange(4), classNum, ones(classNum)*1,...               % X_min, X_max, Y_min,  Y_max, lineNum, lineWidth
    mat2cell(classUsages, ones(1, classNum), houresNum), ...                                            % Data
    'Avrage Day Load Profile', 'Time(hr)', 'Power (W)', ...                                             % 
    {'Class A','Class B', 'Class C'}, '.\Result\365DayloadProfile.png');                                % legendNames, fileSave

%%
%clc;
disp('Saving Data Arrays in .mat files ...');
% Save the array to a MAT file
save('.\MatData\numFamilyMembers.mat'      , 'numFamilyMembers'      );
save('.\MatData\houseClass.mat'            , 'houseClass'            );
save('.\MatData\applianceCounts.mat'       , 'applianceCounts'       );
save('.\MatData\applianceUsages.mat'       , 'applianceUsages'       );
save('.\MatData\hourlyHouseUsages.mat'     , 'hourlyHouseUsages'     );

save('.\MatData\classHousesNum.mat'        , 'classHousesNum'        );
save('.\MatData\classHousesUsage.mat'      , 'classHousesUsage'      );

save('.\MatData\classUsages.mat'           , 'classUsages'           );
save('.\MatData\DaysUsage.mat'             , 'DaysUsage'             );
save('.\MatData\max_monthDaysUsage.mat'    , 'max_monthDaysUsage'    );
save('.\MatData\min_monthDaysUsage.mat'    , 'min_monthDaysUsage'    );

save('.\MatData\avgDayHoursLoadProfile.mat', 'avgDayHoursLoadProfile');

%%
data_timeName = (strcat(string(TempratureReads(:, 1)), '/', string(TempratureReads(:, 2)), '/', string(TempratureReads(:, 3)), '-', string(TempratureReads(:, 4))))';

%%
%clc;
disp('Storing the usage of each house per hour in Excell sheet ...');

% loadprof_SaveExcellData( rawNum, colNum, colNames, colData, sheetNum, sheetNames, namesExtend, sheetData, fileName, sheetName);
loadprof_SaveExcellData(numHouses, 2, ...                                                               %rawNum, colNum,
    {'House_ID', 'Category'}, {(1:numHouses)', houseClass'}, ...                                         %colNames, colData,
    houresNum, data_timeName, '', hourlyHouseUsages, ...                                                %sheetNum, sheetNames, namesExtend, sheetData,
    'survay.xlsx', 'loadProfile');                                                                      %fileName, sheetName

%%
%clc;
disp('Storing the usage of each class of houses per hour in Excell sheet ...');

for i = 1:classNum
    k = classHousesNum(i);
    % loadprof_SaveExcellData( rawNum, colNum, colNames, colData, sheetNum, sheetNames, namesExtend, sheetData, fileName, sheetName);
    loadprof_SaveExcellData(k, 1, ...                                                               %rawNum, colNum,
        {'House_ID'}, {(1:k)'}, ...                                                                 %colNames, colData,
        houresNum, data_timeName, '', reshape(classHousesUsage(i,1:k,:), [k houresNum]), ...        %sheetNum, sheetNames, namesExtend, sheetData,
        'classHousesUsage.xlsx', strcat('Class', string(i)));                                       %fileName, sheetName  
    clear k;
end

%%
%clc;
disp('Storing the avg usage of each class of houses per hour in Excell sheet ...');

% loadprof_SaveExcellData( rawNum, colNum, colNames, colData, sheetNum, sheetNames, namesExtend, sheetData, fileName, sheetName);
loadprof_SaveExcellData(classNum, 1, ...                                                                %rawNum, colNum,
    {'Category'}, {(1:classNum)'}, ...                                                                  %colNames, colData,
    houresNum, data_timeName, '', classUsages, ...                                                      %sheetNum, sheetNames, namesExtend, sheetData,
    'classHousesUsage.xlsx', 'loadProfile_Sum');                                                        %fileName, sheetName
%%
%clc;
% Stop the timer
endTime = toc(startTime);
End_Time = datestr(now);

% Display the timing information
disp(['Start Time: ' Start_Time]);
disp(['End Time: ' End_Time]);
disp(['Total Time: ' num2str(endTime) ' seconds']);

%%
%==============================================================================================================================================
% loadprof_downloadTemp
% download the temperature data of the required site based on the longitude, the latitude, and the year.
%==============================================================================================================================================
function [] = loadprof_downloadTemp(longitude, latitude , year)

% Specify the URL for the NASA POWER Data Access Viewer
url = 'https://power.larc.nasa.gov/api/temporal/hourly/point';

% Specify the parameters for your request
parameters = struct(...
    'Time', 'LST', ...
    'parameters', 'T2M', ...
    'community', 'RE', ...
    'longitude', string(longitude), ...
    'latitude', string(latitude), ...
    'start', strcat(string(year), '0101'), ...
    'end', strcat(string(year), '1231'), ...
    'format', 'CSV' ...
);

% Construct the full URL with parameters
paramStr = join(cellfun(@(name,value)sprintf('%s=%s',name,value), fieldnames(parameters), struct2cell(parameters), 'UniformOutput', false), '&');
fullURL = [url '?' paramStr{1}];

% Download the data file
websave('Temp_Read.csv', fullURL);

% end loadprof_downloadTemp

%%
%==============================================================================================================================================
% loadprof_loadExcellData
% load the data from the excell file
%==============================================================================================================================================
function allTables = loadprof_loadExcellData(fileName)

% Get sheet names from the Excel file
sheetNames = sheetnames(fileName);

% Initialize a cell array to store tables
allTables = cell(1, numel(sheetNames));

% Read each sheet into a table and store it in the cell array
for i = 1:numel(sheetNames)
    % Create a cell array to store the tables
    allTables{i} = readtable(fileName, 'Sheet', sheetNames{i});
end

% end loadprof_loadExcellData

%%
%==============================================================================================================================================
% loadprof_GenerateData
% calculate the No. of family members per house, the houses devices count, power rate, and the houses class to generate the hourly houses usage
%==============================================================================================================================================
function [numFamilyMembers, applianceCounts, applianceUsages, houseClass, hourlyHouseUsages] = ...
    loadprof_GenerateData(numHouses, applianceNum, houresNum, percentageRange, Prop_Struct, TempratureReads)

applianceRanges = reshape(mat2cell(permute(reshape(cell2mat(Prop_Struct.Range)', 2, 16, 3), [1 2 3]), 2, ones(1, 16), ones(1, 3)), [16, 3]);
powerRatings    = reshape(mat2cell(permute(reshape(cell2mat(Prop_Struct.Rate )', 2, 16, 3), [1 2 3]), 2, ones(1, 16), ones(1, 3)), [16, 3]);

% Initialize tables for appliance count
applianceCounts   = zeros(numHouses, applianceNum);
applianceUsages   = zeros(numHouses, applianceNum);
hourlyHouseUsages = zeros(numHouses, houresNum   );

temperatureSetPoint = mean(TempratureReads(:,5));
dayNum  = weekday(datetime(strcat(string(TempratureReads(1, 1)), '-', string(TempratureReads(1, 2)), '-', string(TempratureReads(1, 3))), 'InputFormat', 'yyyy-MM-dd') );

% Generate random data for the number of family members in each house (3 to 10 members)
numFamilyMembers = randi([3, 10], numHouses, 1);
houseClass       = arrayfun(@(x) find(rand() <= cumsum(percentageRange), 1, 'first'), 1:numHouses);

fprintf(1, 'Generating Survay appliance count and rate, class, and hourly usage for house No.%5i\n', 0);
% Generate random appliance counts and usage hours
for i = 1:numHouses
    fprintf(1, '\b\b\b\b\b\b%5i\n', i);
    
    
    Category       = houseClass(i);
    MemberOverLoad = numFamilyMembers(i)/10;
    
    % Generate random appliance counts and usage hours
    HouseApplianceRanges = arrayfun(@(x) [(double(rand < Prop_Struct.Percentage(x)))*randi(applianceRanges{x,Category}), applianceRanges{x,Category}(2)], 1:applianceNum, 'UniformOutput', false);
    applianceCounts(i,:) = arrayfun(@(x) randi(HouseApplianceRanges{x}    ), 1:applianceNum);
    applianceUsages(i,:) = arrayfun(@(x) randi(powerRatings   {x,Category}), 1:applianceNum);
    
    for j = 1:houresNum
        
        TempIndex = TempratureReads(j, 5);
        hourIndex = TempratureReads(j, 4) + 1;
        if(hourIndex == 0)
            dayNum = mod(dayNum, 7) + 1;
        end
        dayIndex  = (dayNum == 5) + 1;
        
%         appliancePropability = cellfun(@(p, t) ...
%             double(rand <= p(hourIndex, dayIndex)) * ((randi([int32(p(hourIndex, dayIndex) * 100), 100]) / 100) ...
%             + (double((sign(TempIndex - temperatureSetPoint) * t) > 0) * abs(TempIndex - temperatureSetPoint)/temperatureSetPoint)) ...
%             , Prop_Struct.Prop, Prop_Struct.Temp);
%         
        appliancePropability = arrayfun(@(x) ...
            double(rand <= Prop_Struct.Prop{x}(hourIndex, dayIndex)) * ((randi([int32(Prop_Struct.Prop{x}(hourIndex, dayIndex) * 100), 100]) / 100) ...
            + (double((sign(TempIndex - temperatureSetPoint) * Prop_Struct.Temp(x)) > 0) * abs(TempIndex - temperatureSetPoint)/temperatureSetPoint)) ...
            , 1:applianceNum);
        
        appliancePropability(16) = appliancePropability(16) + MemberOverLoad;
        
        appliancePropability = arrayfun(@(x) applianceUsages(i, x) * appliancePropability(x) * (Prop_Struct.TimeCycle(x)/60), 1:applianceNum);
        
        appliancePropability = appliancePropability + arrayfun(@(x) (double(appliancePropability(x) <= 0) * Prop_Struct.Standby(x) * applianceCounts(i, x)), 1:applianceNum);
        
        hourlyHouseUsages(i, j) = sum(applianceCounts(i, :) .* appliancePropability);
        
    end
end

% end loadprof_GenerateData

%%
%==============================================================================================================================================
% loadprof_SaveExcellData
% save data to excell sheet
%==============================================================================================================================================
function [] = loadprof_SaveExcellData(rawNum, colNum, colNames, colData, sheetNum, sheetNames, namesExtend, sheetData, fileName, sheetName)

if (colNum == width(colNames)) && (colNum == width(colData)) && (sheetNum == width(sheetNames)) && (sheetNum == width(sheetData))
    disp('Writing table ID ...');
    % Create a table with house ID, family members, and device counts per category
    applianceTable = table();
    for i = 1:colNum
        applianceTable{1:rawNum, colNames(i)} = colData{i};
    end
    
    disp('Writing Sheet Data ...');
    % Add the usage hours as a new column
    sheetData = mat2cell(sheetData, rawNum, ones(1, sheetNum));
    
    fprintf(1, 'Write Column No.%5i\n', 0);
    for i = 1:sheetNum
        fprintf(1, '\b\b\b\b\b\b%5i\n', i);
        applianceTable{1:rawNum, strcat(sheetNames{i}, namesExtend)} = sheetData{i};
    end
    
    disp('Writing in the Excell sheet ...');
    % Write the table to a xlsx file
    writetable(applianceTable, strcat('.\Result\', fileName), 'Sheet', sheetName, 'Range', 'A1');
    
    for i = 1:98
        fprintf(1, '\b');
    end
    
else
    error('wrong data input');
end

% end loadprof_SaveExcellData

%%
%==============================================================================================================================================
% loadprof_filterData
% filter the hourly usage data from white noise
%==============================================================================================================================================
function retval = loadprof_filterData(width, cutoff, order, data)

% cutoff_frequency adjust the cutoff frequency as needed    2195 or 4390;
% order            adjust the filter order as needed        2 to 4

% Design a Butterworth low-pass filter
t = linspace(0, 1, width);  % time vector
[b, a] = butter(order, cutoff / (1 / (2 * mean(diff(t)))), 'low');

% Apply the filter to the signal
retval = filtfilt(b, a, data);

% end loadprof_filterData

%%
%==============================================================================================================================================
% loadprof_saveSurf
% filter the hourly usage data from white noise
%==============================================================================================================================================
function [] = loadprof_saveSurf(X_min, X_max, Y_min, Y_max, Z_min, Z_max, Data, Xlabel, Ylabel, Zlabel, fileSave)

% Define common styling parameters
fontSize = 16;
fontWeight = 'bold';
lineWidth  = 2;

figure('WindowState', 'maximized');

[X, Y] = meshgrid(X_min:X_max,Y_min:Y_max);
surf(X, Y, Data);
colormap(jet(256));

xlim([X_min X_max]);
ylim([Y_min Y_max]);
zlim([Z_min Z_max]);

xlabel(Xlabel);
ylabel(Ylabel);
zlabel(Zlabel);

set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
grid on;
saveas(gcf,fileSave);
close();

% end loadprof_saveSurf

%%
%==============================================================================================================================================
% loadprof_saveSurfSub
% filter the hourly usage data from white noise
%==============================================================================================================================================
function [] = loadprof_saveSurfSub(X_min, X_max, Y_min, Y_max, Z_min, Z_max, Data, Xlabel, Ylabel, Zlabel, fileSave)

% Define common styling parameters
fontSize = 16;
fontWeight = 'bold';
lineWidth  = 2;

figure('WindowState', 'maximized');

[X, Y] = meshgrid(X_min:X_max,Y_min:Y_max);

subplot(1,2,1);
surf(X, Y, Data);
colormap(jet(256));

xlim([X_min X_max]);
ylim([Y_min Y_max]);
zlim([Z_min Z_max]);

xlabel(Xlabel);
ylabel(Ylabel);
zlabel(Zlabel);

set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
grid on;

subplot(1,2,2);
surf(X, Y, Data);
colormap(jet(256));
colorbar;
view(2);

xlim([X_min X_max]);
ylim([Y_min Y_max]);
zlim([Z_min Z_max]);

xlabel(Xlabel);
ylabel(Ylabel);
zlabel(Zlabel);

set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
grid on;

saveas(gcf,fileSave);
close();

% end loadprof_saveSurfSub

%%
%==============================================================================================================================================
% loadprof_saveplot
% filter the hourly usage data from white noise
%==============================================================================================================================================
function [] = loadprof_saveplot(X_min, X_max, Y_min, Y_max, lineNum, lineWidth, Data, Title, Xlabel, Ylabel, legendNames, fileSave)

figure('WindowState', 'maximized');

% Define common styling parameters
TfontSize  = 20;
LfontSize  = 18;
fontWeight = 'bold';
line       = {'-.', '--', '-'};

for i = lineNum:-1:1
    plot((X_min:X_max), Data{i}, line{i}, 'LineWidth', lineWidth(i));
    hold on;
end

xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', 2);
legend(legendNames,'Location','northwest');
xlabel(Xlabel);
ylabel(Ylabel);
title(Title, 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

saveas(gcf,fileSave);
close();

% end loadprof_saveplot

%%
%==============================================================================================================================================
% loadprof_saveplot
% filter the hourly usage data from white noise
%==============================================================================================================================================
function [] = loadprof_saveplotsub(X_min, X_max, Y_min, Y_max, lineNum, lineWidth, Data, Title, Xlabel, Ylabel, legendNames, fileSave)

figure('WindowState', 'maximized');

% Define common styling parameters
TfontSize = 20;
LfontSize = 14;
fontWeight = 'bold';
line       = {'-.', '--', '-'};
for i = 1:4
    % Plotting the first subplot
    subplot(2, 2, i);
    for j = lineNum:-1:1
        plot([X_min:X_max], Data{i, j}, line{j}, 'LineWidth', lineWidth);
        hold on;
    end
    xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
    set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
    legend(legendNames,'Location','northwest', 'FontSize', 12);
    xlabel(Xlabel);
    ylabel(Ylabel);
    title(Title{i}, 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.23, 0]);
end

% Adjust subplot positions to reduce space
set(gcf, 'Position', [100, 100, 1200, 600]); % Adjust figure size
subplots = get(gcf, 'Children');
for i = 1:length(subplots)
    subplots(i).Position(1) = subplots(i).Position(1) - 0.07; % Adjust horizontal position
    subplots(i).Position(3) = subplots(i).Position(3) + 0.07; % Adjust width
    subplots(i).Position(2) = subplots(i).Position(2) - 0.027; % Adjust vertical position
    subplots(i).Position(4) = subplots(i).Position(4) + 0.027; % Adjust height
end

saveas(gcf,fileSave);
close();

% end loadprof_saveplot


