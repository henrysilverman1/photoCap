clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script is made to process capacitance versus time data exported from
%the Zurich monochromator, if you would like to process a file that was
%exported with bias voltages as well see v2. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the path to your data file
filename = 'PhotoCap\data\3-13-24_thermalTrans_noLight.txt';

% Read the data from the file
data = readtable(filename, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
time = data.Var1; % Time data
capacitance = data.Var2; % Capacitance data

posTime = abs(time(1))+time; %shift time data over so all values are positive
pulseSteadyTime = 3500; %Steady state time width in sec
thermalSteadyTime = 3500; %Steady state time width in sec
pulseMargin = 0;
thermMargin=0;
meanCapWidth = 1000;
avgCap = movmean(capacitance,meanCapWidth); %create a centered moving average representation of the capaicitance with width of meanCapWidth

%Determining pulse steady state bounds
i1=find(capacitance>5.4383e-11,pulseSteadyTime, 'last');
i2=find(capacitance<max(capacitance));
i = intersect(i1,i2);
pulseSteadyStart = posTime(i(1));
pulseSteadyEnd = posTime(i(length(i)-1));

%Determining thermal emission steady state bounds
j1=find(capacitance<5.42687e-11,thermalSteadyTime, 'last');
j2=find(capacitance>min(capacitance));
j = intersect(j1,j2);
thermSteadyStart = posTime(j(1));
thermSteadyEnd = posTime(j(length(j)-1));

%determining steady states averages
avgSteadyTherm = mean(capacitance(j(1):j(length(j)-1)));
avgSteadyPulse = mean(capacitance(i(1):i(length(i)-1)));

%Making derivative array
dData = diff(data);
dCap = dData.Var2;
dTime = (1:length(time)-1);

%Determining pulse bounds
k1=find(capacitance==max(capacitance));
k2=find(capacitance>5.4383e-11,1, 'last');
pulseCap = capacitance(k1-pulseMargin:k2+pulseMargin);
pulseTime = posTime(k1-pulseMargin:k2+pulseMargin);

%Determining thermal emission bounds
l1=find(capacitance==min(capacitance));
l2=find(capacitance<5.42687e-11,1, 'last');
thermStart = time(l1);
thermEnd = time(l2);
thermCap = capacitance(l1-thermMargin:l2+thermMargin);
thermTime = time(l1-thermMargin:l2+thermMargin);

%determining derivative averages

% Fit a logarithmic function to the pulse data
ft = fittype('a + b*log(x+c)', 'independent', 'x', 'dependent', 'y');
opts = fitoptions('Method', 'NonlinearLeastSquares');
opts.StartPoint = [mean(pulseCap) 0.1 1]; % Initial guess for the parameters a, b, and c
[logFit, gof] = fit(pulseTime, pulseCap, ft, opts);

% Plot Time vs. Capacitance
figure;
plot(posTime, capacitance);
hold on;
plot(posTime, avgCap);
title('Time vs. Capacitance');
xlabel('Time (s)');
ylabel('Capacitance (F)');
%xline(pulseSteadyStart,'--r',{'Start','Steady'});
%xline(pulseSteadyEnd,'--r',{'End','Steady'});
xline(pulseSteadyStart,'--');
xline(pulseSteadyEnd,'--');
yline(avgSteadyPulse,'--g',{'Steady Avg =', avgSteadyPulse ' pF'});
xline(thermSteadyStart,'--');
xline(thermSteadyEnd,'--');
yline(avgSteadyTherm,'--b',{'Steady Avg =', avgSteadyTherm ' pF'});
yline(min(capacitance),'--r',{'Min Value =', min(capacitance) ' pF'});

% Plot Time vs. Capacitance (pulse)
figure;
plot(pulseTime, pulseCap);
hold on;
% Plot the logarithmic fit line
plot(logFit, 'r-'); % Plot the fitted curve as a red line
title('Voltage Pulse Response');
xlabel('Time (s)');
ylabel('Capacitance (F)');


% Plot Time vs. Capacitance (thermal emission)
figure;
plot(thermTime, thermCap);
title('Thermal Transient Response');
xlabel('Time (s)');
ylabel('Capacitance (F)');

%Plot derivative of capacitance array versus time
figure;
plot(dTime, dCap);
title('Time vs. Capacitance Derivative');
xlabel('Time (s)');
ylabel('dCapacitance (F/s)');

grid on;

