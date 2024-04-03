clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script is made to process capacitance and voltage bias versus time 
% data exported from the Zurich monochromator.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the path to your data file
filename = 'PhotoCap\Data\3-14-24_thermalTrans_350nm_prePulse';


% Read the data from the file 
data = readtable(filename, 'Format','%f%f', 'Delimiter',';', 'ReadVariableNames',false);
time = data.Var1; % Time data
posTime = abs(time(1))+time; %shift time data over so all values are positive
voltAndCap = data.Var2; % Voltage and capacitance data
% Detect where the dataset switches from voltage to capacitance
% This is where the time resets (i.e., the next time value is less than the previous one)
diffTime = diff(time);
switchPoint = find(diffTime < 0, 1, 'first');

% Split the data into voltage/time and capacitance/time based on the switch point
timeVoltage = posTime(1:switchPoint);
voltage = voltAndCap(1:switchPoint);

timeCapacitance = posTime(switchPoint+1:end);
capacitance = voltAndCap(switchPoint+1:end);
lnCap = log(capacitance);


pulseSteadyTime = 3500; %Steady state time width in sec
thermalSteadyTime = 3500; %Steady state time width in sec
pulseMargin = 0;
thermMargin=0;
meanCapWidth = 100;
avgCap = movmean(capacitance,meanCapWidth); %create a centered moving average representation of the capaicitance with width of meanCapWidth

%Determining pulse steady state bounds
i1=find(capacitance>5.73695e-11,pulseSteadyTime, 'last');
i2=find(capacitance<max(capacitance));
i = intersect(i1,i2);
pulseSteadyStart = timeCapacitance(i(1));
pulseSteadyEnd = timeCapacitance(i(length(i)-1));

%Determining thermal emission steady state bounds
j1=find(capacitance>min(capacitance),thermalSteadyTime, 'last');
% j2=find(capacitance>min(capacitance));
% j = intersect(j1,j2);
thermSteadyStart = timeCapacitance(j1(1));
thermSteadyEnd = timeCapacitance(j1(length(j1)-1));

%determining steady states averages
avgSteadyTherm = mean(capacitance(j1(1):j1(length(j1)-1)));
avgSteadyPulse = mean(capacitance(i(1):i(length(i)-1)));

%Making derivative array
dData = diff(data);
dCap = dData.Var2;
dTime = (1:length(timeCapacitance)-1);

%Determining pulse bounds
k1=find(voltage==0,1,'first');
k2=find(voltage==0,1,'last');
pulseCap = capacitance(k1-pulseMargin:k2+pulseMargin);
pulseLnCap = lnCap(k1-pulseMargin:k2+pulseMargin);
pulseTime = timeCapacitance(k1-pulseMargin:k2+pulseMargin);

%Determining thermal emission bounds
l1=find(voltage==0,1,'last');
l2=find(voltage==-1,1,'last');
thermStart = timeCapacitance(l1);
thermEnd = timeCapacitance(l2);
thermCap = capacitance(l1+5-thermMargin:l2+thermMargin);
thermLnCap = lnCap(l1+5-thermMargin:l2+thermMargin);
thermTime = timeCapacitance(l1+5-thermMargin:l2+thermMargin);

%determining derivative averages

% % Fit a logarithmic function to the pulse data
% ft = fittype('a + b*log(x+c)', 'independent', 'x', 'dependent', 'y');
% opts = fitoptions('Method', 'NonlinearLeastSquares');
% opts.StartPoint = [mean(pulseCap) 0.1 1]; % Initial guess for the parameters a, b, and c
% [logFit, gof] = fit(pulseTime, pulseCap, ft, opts);

% Plot Time vs. Capacitance
figure;
plot(timeCapacitance, capacitance);
hold on;
legend on;
plot(timeCapacitance, avgCap);
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
%yline(min(capacitance),'--r',{'Min Value =', min(capacitance) ' pF'});

% Plot Time vs. Capacitance (pulse)
figure;
plot(pulseTime, pulseCap);
hold on;

% Plot the logarithmic fit line
%plot(logFit, 'r-'); % Plot the fitted curve as a red line
title('Voltage Pulse Response');
xlabel('Time (s)');
ylabel('Capacitance (F)');
% xline(thermSteadyStart,'--');
% xline(thermSteadyEnd,'--');
% yline(avgSteadyTherm,'--b',{'Steady Avg =', avgSteadyTherm ' pF'});


% Plot Time vs. Capacitance (thermal emission)
figure;
plot(thermTime, thermCap);
hold on;
%plot(thermTime, thermCap);
title('Thermal Transient Response');
xlabel('Time (s)');
ylabel('Capacitance (F)');
% xline(pulseSteadyStart,'--');
% xline(pulseSteadyEnd,'--');
% yline(avgSteadyPulse,'--g',{'Steady Avg =', avgSteadyPulse ' pF'});

% Plot Time vs. ln(Capacitance) Pulse
figure(3);
plot(log(pulseTime), log(pulseCap));
hold on;
% Plot the logarithmic fit line
%plot(logFit, 'r-'); % Plot the fitted curve as a red line
title('Voltage Pulse Response');
xlabel('Time (s)');
ylabel('ln(Capacitance) (F)');
% xline(thermSteadyStart,'--');
% xline(thermSteadyEnd,'--');
% yline(avgSteadyTherm,'--b',{'Steady Avg =', avgSteadyTherm ' pF'});


% Plot Time vs. ln(Capacitance) Thermal Emission
figure;
plot(thermTime, thermLnCap);
title('Thermal Transient Response');
xlabel('Time (s)');
ylabel('ln(Capacitance) (F)');
% xline(pulseSteadyStart,'--');
% xline(pulseSteadyEnd,'--');
% yline(avgSteadyPulse,'--g',{'Steady Avg =', avgSteadyPulse ' pF'});

%Plot derivative of capacitance array versus time
figure;
plot(dTime, dCap);
title('Time vs. Capacitance Derivative');
xlabel('Time (s)');
ylabel('dCapacitance (F/s)');

grid on;

