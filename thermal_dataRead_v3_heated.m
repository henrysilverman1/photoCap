clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script is made to process capacitance and voltage bias versus time 
% data exported from the Zurich monochromator.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the path to your data file
filename = 'PhotoCap\Data\3-28-24_thermalTrans_heated_400nm_2';


% Read the data from the file 
data = readtable(filename, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
time = data.Var1; % Time data
posTime = abs(time(1))+time; %shift time data over so all values are positive
biasResCap = data.Var2; % Voltage and capacitance data
% Detect where the dataset switches from voltage to capacitance
% This is where the time resets (i.e., the next time value is less than the previous one)
diffTime = diff(time);
switchPoint1 = find(diffTime < 0, 1, 'first');
switchPoint2 = find(diffTime < 0, 1, 'last');

% Split the data into voltage/time, resistance/time and capacitance/time
% based on the switch points
timeBias = posTime(1:switchPoint1);
bias = biasResCap(1:switchPoint1);

timeResistance = posTime(switchPoint1+1:switchPoint2);
resistance = biasResCap(switchPoint1+1:switchPoint2);

timeCapacitance = posTime(switchPoint2+1:end);
capacitance = biasResCap(switchPoint2+1:end);

%determine idicies of pulse bounds
pulseStart = find(bias == 0, 1, 'first');
pulseEnd = find(bias == 0, 1, 'last');


% Plot Time vs. Capacitance
figure;
plot(timeCapacitance, capacitance);
hold on;
legend on;
title('Time vs. Capacitance');
xlabel('Time (s)');
ylabel('Capacitance (F)');
%xline(pulseSteadyStart,'--r',{'Start','Steady'});
%xline(pulseSteadyEnd,'--r',{'End','Steady'});
xline(700,'--r',{'Light on'});
xline(900,'--r',{'Light off'});
xline(posTime(pulseStart),'--r',{'Begin voltage pulse'});
xline(posTime(pulseEnd),'--r',{'End voltage pulse'});
%yline(min(capacitance),'--r',{'Min Value =', min(capacitance) ' pF'});

% Plot Time vs. 1/Resistance
figure;
plot(timeResistance, 1/resistance);
hold on;
legend on;
title('Time vs. 1/Resistance');
xlabel('Time (s)');
ylabel('1/Resistance (1/Ohm)');
%xline(pulseSteadyStart,'--r',{'Start','Steady'});
%xline(pulseSteadyEnd,'--r',{'End','Steady'});
xline(200,'--r',{'Light on'});
xline(300,'--r',{'Light off'});
xline(posTime(pulseStart),'--r',{'Begin voltage pulse'});
xline(posTime(pulseEnd),'--r',{'End voltage pulse'});
%yline(min(capacitance),'--r',{'Min Value =', min(capacitance) ' pF'});