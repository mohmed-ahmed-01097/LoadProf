%%
clc;
clear;
%%
% Appliances Avilability, Function Case, Time Cycle and Standby Power %
applianceName       =  {{'Routers'        ,'WashingMachines','dishwashers'    ,'Heaters'        ,'Refrigerators'  ,'Freazers'       ,'TVs'            ,'PCs'            ,'Ovens'          ,'Kettles'        ,'Microwaves'     ,'AirConditioning','Fans'           ,'Irons'          ,'Lighting'       ,'Others'         }};
applianceCase       =  {{'Continuous'     ,'Cold'           ,'Cold'           ,'Cold'           ,'Cold'           ,'Cold'           ,'Standby'        ,'Standby'        ,'Active'         ,'Active'         ,'Active'         ,'Active'         ,'Active'         ,'Active'         ,'Active'         ,'Active'         }};
appliancePercentage =  {[.90              ,.96              ,.45              ,.88              ,.96              ,.63              ,.96              ,.88              ,.90              ,.88              ,.74              ,.88              ,.88              ,.88              ,1.00             ,1.00             ]};
applianceTimeCycle  =  {[ 60              , 40              , 20              , 45              , 30              , 30              , 60              , 60              , 25              , 10              , 15              , 30              , 60              , 15              , 60              , 30              ]};
applianceAmbientTemp=  {[ 0               , 0               , 0               , -1              , 1               , 1               , 0               , 1               , -1              , -1              , -1              , 1               , 1               , -1              , 0               , 1               ]};
applianceStandby    =  {[ 0               , 0               , 0               , 0               , 10              , 10              , 8               , 5               , 3               , 0               , 3               , 5               , 0               , 0               , 0               , 10              ]};
% Appliances Power Rate, Num Range %
applianceRating     = {{[[5, 15]          ;[300, 1000]      ;[1000, 1500]     ;[500, 2500]      ;[80, 150]        ;[80, 150]        ;[30, 250]        ;[50, 500]        ;[600, 1500]      ;[1000, 1500]     ;[600, 1500]      ;[500, 1500]      ;[10, 100]        ;[250, 1000]      ;[10, 50]         ;[500, 2500]      ];...
                        [[15, 30]         ;[750, 1250]      ;[1000, 2000]     ;[1000, 3000]     ;[100, 200]       ;[100, 200]       ;[50, 400]        ;[50, 1000]       ;[1000, 5000]     ;[1000, 3000]     ;[600, 1500]      ;[1000, 5000]     ;[30, 150]        ;[500, 1500]      ;[30, 60]         ;[500, 3500]      ];...
                        [[30, 50]         ;[1000, 2500]     ;[1500, 2500]     ;[1000, 5000]     ;[100, 800]       ;[100, 800]       ;[100, 500]       ;[100, 1500]      ;[1500, 5000]     ;[2000, 3500]     ;[1000, 3000]     ;[2000, 10000]    ;[50, 250]        ;[800, 2000]      ;[40, 500]        ;[500, 5000]      ]}};
applianceRange      = {{[[0, 1]           ;[1, 1]           ;[0, 0]           ;[0, 1]           ;[1, 1]           ;[0, 0]           ;[0, 1]           ;[0, 1]           ;[0, 1]           ;[0, 1]           ;[0, 0]           ;[0, 0]           ;[0, 3]           ;[0, 1]           ;[4, 6]           ;[1, 1]           ];...
                        [[0, 1]           ;[1, 2]           ;[0, 1]           ;[1, 2]           ;[1, 2]           ;[0, 1]           ;[1, 2]           ;[1, 2]           ;[0, 1]           ;[1, 1]           ;[0, 1]           ;[0, 2]           ;[2, 5]           ;[1, 1]           ;[7, 10]          ;[1, 1]           ];...
                        [[1, 1]           ;[1, 2]           ;[1, 1]           ;[1, 3]           ;[1, 3]           ;[1, 2]           ;[1, 3]           ;[1, 3]           ;[0, 1]           ;[1, 1]           ;[1, 1]           ;[1, 3]           ;[4, 7]           ;[1, 1]           ;[11, 15]         ;[1, 1]           ]}};
% Appliances Probability %
applianceProbability= {{[[1, 1]           ;[.05, .17]       ;[.05, .17]       ;[.05, .17]       ;[.42, .42]       ;[.42, .42]       ;[.34, .24]       ;[.34, .24]       ;[.04, .02]       ;[.04, .02]       ;[.04, .02]       ;[.26, .10]       ;[.99, .99]       ;[.00, .00]       ;[.26, .10]       ;[.26, .10]       ];...
                        [[1, 1]           ;[.00, .10]       ;[.00, .10]       ;[.00, .10]       ;[.42, .42]       ;[.42, .42]       ;[.19, .12]       ;[.19, .12]       ;[.01, .02]       ;[.01, .02]       ;[.01, .02]       ;[.13, .03]       ;[.99, .99]       ;[.00, .00]       ;[.13, .03]       ;[.13, .08]       ];...
                        [[1, 1]           ;[.00, .04]       ;[.00, .04]       ;[.00, .04]       ;[.42, .42]       ;[.42, .42]       ;[.09, .07]       ;[.09, .07]       ;[.00, .04]       ;[.00, .04]       ;[.00, .04]       ;[.12, .03]       ;[.99, .99]       ;[.00, .00]       ;[.12, .03]       ;[.12, .08]       ];...
                        [[1, 1]           ;[.00, .04]       ;[.00, .04]       ;[.00, .04]       ;[.42, .42]       ;[.42, .42]       ;[.08, .06]       ;[.08, .06]       ;[.00, .04]       ;[.00, .04]       ;[.00, .04]       ;[.12, .08]       ;[.99, .99]       ;[.00, .00]       ;[.12, .05]       ;[.12, .08]       ];...
                        [[1, 1]           ;[.00, .04]       ;[.00, .04]       ;[.00, .04]       ;[.42, .42]       ;[.42, .42]       ;[.09, .07]       ;[.09, .07]       ;[.00, .18]       ;[.00, .18]       ;[.00, .18]       ;[.14, .17]       ;[.99, .99]       ;[.00, .00]       ;[.14, .05]       ;[.13, .10]       ];...
                        [[1, 1]           ;[.00, .10]       ;[.00, .10]       ;[.00, .10]       ;[.42, .42]       ;[.42, .42]       ;[.10, .13]       ;[.10, .13]       ;[.02, .26]       ;[.02, .26]       ;[.02, .26]       ;[.15, .26]       ;[.99, .99]       ;[.00, .00]       ;[.15, .08]       ;[.17, .20]       ];...
                        [[1, 1]           ;[.00, .17]       ;[.00, .17]       ;[.00, .17]       ;[.42, .42]       ;[.42, .42]       ;[.10, .21]       ;[.10, .21]       ;[.17, .52]       ;[.17, .52]       ;[.17, .52]       ;[.21, .36]       ;[.99, .99]       ;[.01, .01]       ;[.21, .10]       ;[.21, .31]       ];...
                        [[1, 1]           ;[.07, .29]       ;[.07, .29]       ;[.07, .29]       ;[.42, .42]       ;[.42, .42]       ;[.15, .25]       ;[.15, .25]       ;[.77, .58]       ;[.77, .58]       ;[.77, .58]       ;[.41, .37]       ;[.11, .11]       ;[.02, .01]       ;[.41, .17]       ;[.63, .58]       ];...
                        [[1, 1]           ;[.25, .37]       ;[.25, .37]       ;[.25, .37]       ;[.42, .42]       ;[.42, .42]       ;[.24, .34]       ;[.24, .34]       ;[.84, .57]       ;[.84, .57]       ;[.84, .57]       ;[.51, .39]       ;[.02, .02]       ;[.04, .02]       ;[.51, .34]       ;[.71, .67]       ];...
                        [[1, 1]           ;[.76, .46]       ;[.76, .46]       ;[.76, .46]       ;[.42, .42]       ;[.42, .42]       ;[.34, .32]       ;[.34, .32]       ;[.89, .41]       ;[.89, .41]       ;[.89, .41]       ;[.50, .43]       ;[.02, .02]       ;[.15, .25]       ;[.50, .53]       ;[.74, .77]       ];...
                        [[1, 1]           ;[.65, .47]       ;[.65, .47]       ;[.65, .47]       ;[.42, .42]       ;[.42, .42]       ;[.39, .32]       ;[.39, .32]       ;[.77, .35]       ;[.77, .35]       ;[.77, .35]       ;[.43, .47]       ;[.02, .02]       ;[.22, .50]       ;[.43, .50]       ;[.76, .85]       ];...
                        [[1, 1]           ;[.72, .47]       ;[.72, .47]       ;[.72, .47]       ;[.42, .42]       ;[.42, .42]       ;[.49, .38]       ;[.49, .38]       ;[.65, .32]       ;[.65, .32]       ;[.65, .32]       ;[.38, .52]       ;[.02, .02]       ;[.13, .42]       ;[.38, .43]       ;[.71, .90]       ];...
                        [[1, 1]           ;[.70, .47]       ;[.70, .47]       ;[.70, .47]       ;[.42, .42]       ;[.42, .42]       ;[.49, .38]       ;[.49, .38]       ;[.34, .39]       ;[.34, .39]       ;[.34, .39]       ;[.36, .55]       ;[.09, .09]       ;[.10, .52]       ;[.36, .39]       ;[.67, .81]       ];...
                        [[1, 1]           ;[.77, .47]       ;[.77, .47]       ;[.77, .47]       ;[.42, .42]       ;[.42, .42]       ;[.59, .40]       ;[.59, .40]       ;[.36, .45]       ;[.36, .45]       ;[.36, .45]       ;[.43, .51]       ;[.72, .72]       ;[.04, .60]       ;[.43, .41]       ;[.55, .67]       ];...
                        [[1, 1]           ;[.73, .47]       ;[.73, .47]       ;[.73, .47]       ;[.42, .42]       ;[.42, .42]       ;[.61, .48]       ;[.61, .48]       ;[.64, .58]       ;[.64, .58]       ;[.64, .58]       ;[.50, .49]       ;[.95, .95]       ;[.25, .52]       ;[.50, .46]       ;[.50, .56]       ];...
                        [[1, 1]           ;[.73, .61]       ;[.73, .61]       ;[.73, .61]       ;[.42, .42]       ;[.42, .42]       ;[.68, .64]       ;[.68, .64]       ;[.66, .88]       ;[.66, .88]       ;[.66, .88]       ;[.55, .51]       ;[.76, .76]       ;[.15, .69]       ;[.55, .50]       ;[.40, .48]       ];...
                        [[1, 1]           ;[.74, .68]       ;[.74, .68]       ;[.74, .68]       ;[.42, .42]       ;[.42, .42]       ;[.71, .80]       ;[.68, .80]       ;[.68, .99]       ;[.68, .99]       ;[.68, .99]       ;[.60, .58]       ;[.08, .08]       ;[.10, .70]       ;[.60, .58]       ;[.36, .42]       ];...
                        [[1, 1]           ;[.74, .72]       ;[.74, .72]       ;[.74, .72]       ;[.42, .42]       ;[.42, .42]       ;[.74, .83]       ;[.74, .80]       ;[.74, .99]       ;[.74, .99]       ;[.74, .99]       ;[.67, .72]       ;[.02, .02]       ;[.02, .62]       ;[.67, .67]       ;[.32, .44]       ];...
                        [[1, 1]           ;[.77, .78]       ;[.77, .78]       ;[.77, .78]       ;[.42, .42]       ;[.42, .42]       ;[.79, .90]       ;[.79, .87]       ;[.73, .92]       ;[.73, .92]       ;[.73, .92]       ;[.71, .78]       ;[.34, .34]       ;[.01, .42]       ;[.73, .82]       ;[.36, .45]       ];...
                        [[1, 1]           ;[.77, .86]       ;[.77, .86]       ;[.77, .86]       ;[.42, .42]       ;[.42, .42]       ;[.83, .96]       ;[.83, .96]       ;[.72, .82]       ;[.72, .82]       ;[.72, .82]       ;[.69, .82]       ;[.84, .84]       ;[.00, .20]       ;[.76, .91]       ;[.38, .46]       ];...
                        [[1, 1]           ;[.74, .82]       ;[.74, .82]       ;[.74, .82]       ;[.42, .42]       ;[.42, .42]       ;[.68, .80]       ;[.68, .80]       ;[.69, .58]       ;[.69, .58]       ;[.69, .58]       ;[.66, .75]       ;[.99, .99]       ;[.00, .15]       ;[.71, .98]       ;[.40, .47]       ];...
                        [[1, 1]           ;[.61, .70]       ;[.61, .70]       ;[.61, .70]       ;[.42, .42]       ;[.42, .42]       ;[.53, .64]       ;[.53, .64]       ;[.41, .38]       ;[.41, .38]       ;[.41, .38]       ;[.62, .66]       ;[.99, .99]       ;[.00, .05]       ;[.62, .85]       ;[.41, .49]       ];...
                        [[1, 1]           ;[.39, .51]       ;[.39, .51]       ;[.39, .51]       ;[.42, .42]       ;[.42, .42]       ;[.48, .48]       ;[.48, .48]       ;[.23, .15]       ;[.23, .15]       ;[.23, .15]       ;[.45, .43]       ;[.92, .92]       ;[.00, .00]       ;[.45, .43]       ;[.39, .47]       ];...
                        [[1, 1]           ;[.10, .20]       ;[.10, .20]       ;[.10, .20]       ;[.42, .42]       ;[.42, .42]       ;[.39, .32]       ;[.39, .32]       ;[.10, .04]       ;[.10, .04]       ;[.10, .04]       ;[.32, .30]       ;[.80, .80]       ;[.00, .00]       ;[.32, .30]       ;[.32, .37]       ]}};
%WeekDay, WeekEnd
%%
reshapedCellArray = cell(1, 16);
temp              = zeros(3, 2);
for i = 1:16
    for j = 1:3
        temp(j,:) = applianceRange{1}{j}(i,:);
    end
    reshapedCellArray{i} = temp;
end
applianceRange = {reshapedCellArray};

temp              = zeros(3, 2);
for i = 1:16
    for j = 1:3
        temp(j,:) = applianceRating{1}{j}(i,:);
    end
    reshapedCellArray{i} = temp;
end
applianceRating = {reshapedCellArray};

temp              = zeros(24,2);
for i = 1:16
    for j = 1:24
        temp(j,:) = applianceProbability{1}{j}(i,:);
    end
    reshapedCellArray{i} = temp;
end
applianceProbability = {reshapedCellArray};

%%
% Appliances Structure 
Prop_Struct = struct('Name'      , applianceName , ...
                     'Case'      , applianceCase, ...
                     'Percentage', appliancePercentage, ...
                     'TimeCycle' , applianceTimeCycle, ...
                     'Temp'      , applianceAmbientTemp, ...
                     'Standby'   , applianceStandby, ...
                     'Rate'      , applianceRating, ...
                     'Range'     , applianceRange, ...
                     'Prop'      , applianceProbability ...
                     );
save('Prop_Struct.mat' , 'Prop_Struct');

%%
% Create a figure
figure('WindowState', 'maximized');

% Define common styling parameters
lineWidth = 2;
TfontSize = 18;
LfontSize = 10;
fontWeight = 'bold';
X_max = 23; Y_max = 1;
X_min = 0;  Y_min = 0;

% Plotting the first subplot
subplot(2, 3, 1);
plot([X_min:X_max], Prop_Struct.Prop{2}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{2}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('WashingMachines, dishwashers, Heaters', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the second subplot
subplot(2, 3, 2);
plot([X_min:X_max], Prop_Struct.Prop{7}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{7}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('TVs, PCs', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the third subplot
subplot(2, 3, 3);
plot([X_min:X_max], Prop_Struct.Prop{9}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{9}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Ovens, Kettles, Microwaves', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the fourth subplot
subplot(2, 3, 4);
plot([X_min:X_max], Prop_Struct.Prop{12}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{12}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('AirConditioning', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the fifth subplot
subplot(2, 3, 5);
plot([X_min:X_max], Prop_Struct.Prop{15}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{15}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Lighting', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the sixth subplot
subplot(2, 3, 6);
plot([X_min:X_max], Prop_Struct.Prop{16}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{16}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Others', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Adjust subplot positions to reduce space
set(gcf, 'Position', [100, 100, 1200, 600]); % Adjust figure size
subplots = get(gcf, 'Children');
for i = 1:length(subplots)
    subplots(i).Position(1) = subplots(i).Position(1) - 0.04; % Adjust horizontal position
    subplots(i).Position(3) = subplots(i).Position(3) + 0.04; % Adjust width
    subplots(i).Position(2) = subplots(i).Position(2) - 0.04; % Adjust vertical position
    subplots(i).Position(4) = subplots(i).Position(4) + 0.04; % Adjust height
end

saveas(gcf, 'Prop.png');
close();
