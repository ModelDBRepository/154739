clear all

nCell = 1000;
tMax = 1000;

P.a = 0.02;
P.b = 0.2;
P.c = -55;
P.d = 2;
P.I = @(t) 6;

P.tauSyn = 10;
P.ESyn = 0;

pCon = 0.03;
gCon = 0.002;
wCon = 1;

P.g = nCell * pCon * gCon * wCon;




%% Solve one-population reduced IZH model


ZZ = odeset();
Init = [-70; -10-1.5; 0];
[tRed, xRed] = ode23s(@IzhPopulation01,[0,tMax],Init,ZZ,P);

% figure;
% plot(tRed, xRed(:, 1));





%% Use Urd+Verdandi for spiking neuron network

if(ispc)
    addpath '.\Norns\Skuld_2_2' '.\Norns\Urd_v1_2' '.\Norns\VerdandiLite_v1_1'
else
    addpath './Norns/Skuld_2_2' './Norns/Urd_v1_2' './Norns/VerdandiLite_v1_1'
end
    

global Network

disp('Preparing simulations')
tic 

% --- Time integration ---

Network.dt = 0.1; % Integration step (in ms)
Network.nStep = round(tMax/Network.dt); % Number of time steps

Network.OutputVm = 1; % 1=Output membrane potentials to Vm.txt, 0=no such output
Network.OutputSp = 1; % 1=Output spike times to Spikes.txt, 0=no such output

fInit = fopen('Inits.txt','w');
fprintf(fInit,'%u\t%g\n%u\t%u',Network.nStep,Network.dt,Network.OutputVm,Network.OutputSp);
fclose(fInit);

I0 = P.I(0);

% --- Populations ---
AddPopulation(...
    'Name','Cells',...
    'nCell', nCell, ...
    'Type','Izhikevich',... 
    'a','Normal', [P.a, 0.001],...
    'b','Normal', [P.b, 0.01],...
    'c','Normal', [P.c, 1],...
    'd','Normal', [P.d, 0.1],...
    'I','Normal', [I0, 0.2],...
    'V','Normal', [-70, 3],...
    'w','Normal', [-10, 5],...
    'Position',rand(nCell,3));

% AddPopulation(...
%     'Name','Icells',...
%     'nCell', 1, ...
%     'Type','LeakyIntegrate',... 
%     'C', 10,...
%     'VRest', -70,...
%     'VThreshold', -66,...
%     'VReset', -80,...
%     'V','Normal',[-70, 4],...
%     'Position',[1,1,0]);

% --- Connections ---    
AddConnectivity(...
    'From','Cells',...
    'To',{'Cells'},...
    'Type','Exponential',...
    'Tau', P.tauSyn, 'E', P.ESyn, 'g', gCon,...
    'Connections','Generate','Probability',pCon,'Weight', wCon, ...
    'Delay','Function',0);
   
% AddConnectivity(...
%     'From','Icells',...
%     'To',{'Ecells'},...
%     'Type','Exponential',...
%     'Tau',10,'E',-80,'g',0.4,...
%     'Connections','Matrix',...
%         [1;
%          0],...
%     'Delay','Function',@(r) r+2);



% --- Output to files 
WriteCells;
WriteConnectivity;
toc

% --- run simulation in C++ environment
disp('Running simulations')
tic 

if(ismac)
    system('./Norns/VerdandiLite_v1_1/VerdandiLite_OSX');
% elseif(ispc)
%     system('.\Norns\VerdandiLite_v1_1\VerdandiLite_WIN32.exe');
else
    error('No binaries available for VerdandiLite. Please compile C++ source files and add modify these Matlab lines.')
end


toc

SkuldOut



%% Do basic data analysis on results

% Obtain synaptic currents

SP = load('Spikes.txt');
[tSpikes, rSpikes] = AnalyzeSpikes(SP, P.tauSyn);

hold on
plot(tRed, xRed(:, 3), 'r')



RasterIDs = 20:20:nCell;
% CellSpikes = cell(numel(RasterIDs),1);

figure;
ax = subplot(3,1,2);
hold off
for iCell = RasterIDs
    IDX = SP(:,2)==iCell;
    CellSpikes = SP(IDX,1)';
    plot(CellSpikes, iCell*ones(size(CellSpikes)), '.k', 'MarkerSize', 10);
    hold on
end
ylabel('Cell ID');
% set(ax, 'Ylabel', 'Cell ID');
set(ax, 'XTickLabel', {});

subplot(3,1,3)
hold off
plot(tSpikes, nCell*rSpikes, 'b')
hold on
plot(tRed, nCell*xRed(:, 3), 'r')
ylabel('Synapses');
legend('Network', 'Reduction')


figure;
subplot(2,2,1)
plot(xRed(:,1), xRed(:,2));
xlabel('v');
ylabel('u');

subplot(2,2,3)
plot(xRed(:,1), xRed(:,3));
xlabel('v');
ylabel('s');

subplot(2,2,2)
plot(xRed(:,3), xRed(:,2));
xlabel('s');
ylabel('u');


Skuld('SkuldSet.mat')