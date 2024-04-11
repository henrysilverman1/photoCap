% clear;
% clc;
% close all;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %This script is made to process capacitance and voltage bias versus time 
% % data exported from the Zurich monochromator.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Define the path to your data file
% filename1 = 'PhotoCap\Data\3-28-24_thermalTrans_heated_400nm_2';
% filename2 = 'PhotoCap\Data\3-14-24_thermalTrans_350nm_prePulse';
% 
% %read data for filename1
% data1 = readtable(filename1, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
% time1 = data1.Var1; % Time data
% posTime1 = abs(time1(1))+time1; %shift time data over so all values are positive
% voltAndCap1 = data1.Var2; % Voltage and capacitance data
% % Detect where the dataset switches from voltage to capacitance
% % This is where the time resets (i.e., the next time value is less than the previous one)
% diffTime1 = diff(time1);
% switchPoint = find(diffTime1 < 0, 1, 'first');
% 
% % Split the data into voltage/time and capacitance/time based on the switch point
% timeVoltage = posTime1(1:switchPoint);
% voltage = voltAndCap1(1:switchPoint);
% 
% timeCapacitance1 = posTime1(switchPoint+1:end);
% capacitance1 = voltAndCap1(switchPoint+1:end);
% lnCap = log(capacitance1);
% 
% pulseSteadyTime = 3500; %Steady state time width in sec
% thermalSteadyTime = 3500; %Steady state time width in sec
% pulseMargin = 0;
% thermMargin=0;
% meanCapWidth = 100;
% avgCap = movmean(capacitance1,meanCapWidth); %create a centered moving average representation of the capaicitance with width of meanCapWidth
% 
% 
% data = readtable(filename2, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
% time = data.Var1; % Time data
% posTime = abs(time(1))+time; %shift time data over so all values are positive
% biasResCap = data.Var2; % Voltage and capacitance data
% % Detect where the dataset switches from voltage to capacitance
% % This is where the time resets (i.e., the next time value is less than the previous one)
% diffTime = diff(time);
% switchPoint1 = find(diffTime < 0, 1, 'first');
% switchPoint2 = find(diffTime < 0, 1, 'last');
% 
% % Split the data into voltage/time, resistance/time and capacitance/time
% % based on the switch points
% timeBias = posTime(1:switchPoint1);
% bias = biasResCap(1:switchPoint1);
% 
% timeResistance = posTime(switchPoint1+1:switchPoint2);
% resistance = biasResCap(switchPoint1+1:switchPoint2);
% 
% timeCapacitance = posTime(switchPoint2+1:end);
% capacitance = biasResCap(switchPoint2+1:end);
% 
% 
% %determine idicies of pulse bounds for first data
% k1=find(voltage==0,1,'first');
% k2=find(voltage==0,1,'last');
% pulseCap = capacitance1(k1-pulseMargin:k2+pulseMargin);
% pulseLnCap = lnCap(k1-pulseMargin:k2+pulseMargin);
% pulseTime = timeCapacitance1(k1-pulseMargin:k2+pulseMargin);
% 
% %determine idicies of pulse bounds for second data
% pulseStart = find(bias == 0, 1, 'first');
% pulseEnd = find(bias == 0, 1, 'last');
% 
% % Plot Time vs. Capacitance
% figure;
% plot(pulseTime, pulseCap);
% hold on;
% %plot(posTime(pulseStart:pulseEnd), capacitance(pulseStart:pulseEnd))
% legend on;
% title('Time vs. Capacitance Heated Pulse');
% xlabel('Time (s)');
% ylabel('Capacitance (F)');
% %yline(min(capacitance),'--r',{'Min Value =', min(capacitance) ' pF'});

clear;
clc;
close all;

% Define the path to your data file using forward slashes or double backslashes
filename1 = 'PhotoCap/Data/3-28-24_thermalTrans_heated_400nm_2';
filename2 = 'PhotoCap/Data/3-14-24_thermalTrans_350nm_prePulse';

% Read data for filename1
data1 = readtable(filename1, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
time1 = data1.Var1; % Time data
posTime1 = abs(time1(1)) + time1; % Shift time data so all values are positive
voltAndCap1 = data1.Var2; % Voltage and capacitance data

% Detect where the dataset switches from voltage to capacitance
diffTime1 = diff(time1);
switchPoint1 = find(diffTime1 < 0, 1, 'first');

% Split the data into voltage/time and capacitance/time based on the switch point
timeVoltage1 = posTime1(1:switchPoint1);
voltage1 = voltAndCap1(1:switchPoint1);

timeCapacitance1 = posTime1(switchPoint1+1:end);
capacitance1 = voltAndCap1(switchPoint1+1:end);
lnCap1 = log(capacitance1); % Logarithm of capacitance

% Moving average of capacitance
meanCapWidth = 100;
avgCap1 = movmean(capacitance1, meanCapWidth);

% Read data for filename2
data2 = readtable(filename2, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
time2 = data2.Var1; % Time data
posTime2 = abs(time2(1)) + time2; % Shift time data so all values are positive
voltAndCap2 = data2.Var2; % Voltage and capacitance data

% Detect switch points
diffTime2 = diff(time2);
switchPoint1_2 = find(diffTime2 < 0, 1, 'first');
switchPoint2_2 = find(diffTime2 < 0, 1, 'last');

% Split data based on switch points
timeBias = posTime2(1:switchPoint1_2);
bias = voltAndCap2(1:switchPoint1_2);

timeResistance = posTime2(switchPoint1_2+1:switchPoint2_2);
resistance = voltAndCap2(switchPoint1_2+1:switchPoint2_2);

timeCapacitance2 = posTime2(switchPoint2_2+1:end);
capacitance2 = voltAndCap2(switchPoint2_2+1:end);

% Determine indices of pulse bounds for the first data
pulseStart1 = find(voltage1 == 0, 1, 'first');
pulseEnd1 = find(voltage1 == 0, 1, 'last');

% Plot Time vs. Capacitance
figure;
plot(timeCapacitance1(pulseStart1:pulseEnd1), capacitance1(pulseStart1:pulseEnd1));
hold on;

% Ensure the second dataset pulse start and end are defined for plotting
pulseStart2 = find(bias == 0, 1, 'first');
pulseEnd2 = find(bias == 0, 1, 'last');

plot(capacitance2(pulseStart2:pulseEnd2), timeCapacitance2(pulseStart2:pulseEnd2));
legend('Dataset 1', 'Dataset 2');
title('Time vs. Capacitance for Heated Pulse');
xlabel('Time (s)');
ylabel('Capacitance (F)');





