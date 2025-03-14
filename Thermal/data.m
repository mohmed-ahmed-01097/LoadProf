%%
clc;
clear;
%%
% Appliances Avilability, Function Case, Time Cycle and Standby Power %
applianceName       =  {{'Ovens'          ,'Stoves'         ,'Heaters'        ,'Others'         }};
applianceCase       =  {{'Active'         ,'Active'         ,'Active'         ,'Active'         }};
appliancePercentage =  {[.90              ,.88              ,.74              ,1.00             ]};
applianceTimeCycle  =  {[ 25              , 10              , 15              , 30              ]};
applianceAmbientTemp=  {[ -1              , -1              , -1              , 1               ]};
applianceStandby    =  {[ 3               , 0               , 3               , 5               ]};
% Appliances Power Rate, Num Range %
applianceRating     = {{[[1000, 1500]     ;[600, 1500]      ;[500, 1500]      ;[500, 2500]      ];...
                        [[1000, 3000]     ;[600, 1500]      ;[1000, 5000]     ;[500, 3500]      ];...
                        [[2000, 3500]     ;[1000, 3000]     ;[2000, 10000]    ;[500, 5000]      ]}};
applianceRange      = {{[[0, 1]           ;[0, 0]           ;[0, 0]           ;[1, 1]           ];...
                        [[1, 1]           ;[0, 1]           ;[0, 2]           ;[1, 1]           ];...
                        [[1, 1]           ;[1, 1]           ;[1, 3]           ;[1, 1]           ]}};
% Appliances Probability %
applianceProbability= {{[[.04, .02]       ;[.04, .02]       ;[.26, .10]       ;[.26, .10]       ];...
                        [[.01, .02]       ;[.01, .02]       ;[.13, .03]       ;[.13, .08]       ];...
                        [[.00, .04]       ;[.00, .04]       ;[.12, .03]       ;[.12, .08]       ];...
                        [[.00, .04]       ;[.00, .04]       ;[.12, .08]       ;[.12, .08]       ];...
                        [[.00, .18]       ;[.00, .18]       ;[.14, .17]       ;[.13, .10]       ];...
                        [[.02, .26]       ;[.02, .26]       ;[.15, .26]       ;[.17, .20]       ];...
                        [[.17, .52]       ;[.17, .52]       ;[.21, .36]       ;[.21, .31]       ];...
                        [[.77, .58]       ;[.77, .58]       ;[.41, .37]       ;[.63, .58]       ];...
                        [[.84, .57]       ;[.84, .57]       ;[.51, .39]       ;[.71, .67]       ];...
                        [[.89, .41]       ;[.89, .41]       ;[.50, .43]       ;[.74, .77]       ];...
                        [[.77, .35]       ;[.77, .35]       ;[.43, .47]       ;[.76, .85]       ];...
                        [[.65, .32]       ;[.65, .32]       ;[.38, .52]       ;[.71, .90]       ];...
                        [[.34, .39]       ;[.34, .39]       ;[.36, .55]       ;[.67, .81]       ];...
                        [[.36, .45]       ;[.36, .45]       ;[.43, .51]       ;[.55, .67]       ];...
                        [[.64, .58]       ;[.64, .58]       ;[.50, .49]       ;[.50, .56]       ];...
                        [[.66, .88]       ;[.66, .88]       ;[.55, .51]       ;[.40, .48]       ];...
                        [[.68, .99]       ;[.68, .99]       ;[.60, .58]       ;[.36, .42]       ];...
                        [[.74, .99]       ;[.74, .99]       ;[.67, .72]       ;[.32, .44]       ];...
                        [[.73, .92]       ;[.73, .92]       ;[.71, .78]       ;[.36, .45]       ];...
                        [[.72, .82]       ;[.72, .82]       ;[.69, .82]       ;[.38, .46]       ];...
                        [[.69, .58]       ;[.69, .58]       ;[.66, .75]       ;[.40, .47]       ];...
                        [[.41, .38]       ;[.41, .38]       ;[.62, .66]       ;[.41, .49]       ];...
                        [[.23, .15]       ;[.23, .15]       ;[.45, .43]       ;[.39, .47]       ];...
                        [[.10, .04]       ;[.10, .04]       ;[.32, .30]       ;[.32, .37]       ]}};
%WeekDay, WeekEnd
%%
reshapedCellArray = cell(1, length(applianceName{1}));
temp              = zeros(3, 2);
for i = 1:length(applianceName{1})
    for j = 1:3
        temp(j,:) = applianceRange{1}{j}(i,:);
    end
    reshapedCellArray{i} = temp;
end
applianceRange = {reshapedCellArray};

temp              = zeros(3, 2);
for i = 1:length(applianceName{1})
    for j = 1:3
        temp(j,:) = applianceRating{1}{j}(i,:);
    end
    reshapedCellArray{i} = temp;
end
applianceRating = {reshapedCellArray};

temp              = zeros(length(applianceProbability{1}),2);
for i = 1:length(applianceName{1})
    for j = 1:length(applianceProbability{1})
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
subplot(2, 2, 1);
plot([X_min:X_max], Prop_Struct.Prop{1}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{1}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Ovens, Kettles, Microwaves', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the second subplot
subplot(2, 2, 2);
plot([X_min:X_max], Prop_Struct.Prop{2}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{2}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Stoves', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the third subplot
subplot(2, 2, 3);
plot([X_min:X_max], Prop_Struct.Prop{3}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{3}(:, 2)','--*', 'LineWidth', lineWidth);
xlim([X_min X_max]);ylim([Y_min Y_max]);grid on;
set(gca, 'FontSize', LfontSize, 'FontWeight', fontWeight, 'LineWidth', lineWidth);
legend({'WeekDay','WeekEnd'},'Location','southeast');
ylabel('Probability(%)');
xlabel('Time(hr)');
title('Heaters', 'FontSize', TfontSize, 'Units', 'normalized', 'Position', [0.5, -0.185, 0]);

% Plotting the fourth subplot
subplot(2, 2, 4);
plot([X_min:X_max], Prop_Struct.Prop{4}(:, 1)', '-*', [X_min:X_max], Prop_Struct.Prop{4}(:, 2)','--*', 'LineWidth', lineWidth);
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
