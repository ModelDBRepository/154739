clear all

tMax = 2000;

nCellInh = 100;
nCellExc1 = 300;
nCellExc2 = 300;

P.tau_inh = 10;
P.tau_exc = 5;

P.E_inh = -80+15*0;
P.E_exc = 0;

P.Inh.a = 0.02;
P.Inh.b = 0.2;
P.Inh.c = -55;
P.Inh.d = 2;
P.Inh.I0 = 0;
P.Inh.tauSyn = P.tau_inh;

P.Exc1.a = 0.03;
P.Exc1.b = 0.3;
P.Exc1.c = -55;
P.Exc1.d = 2;
P.Exc1.I0 = -3;
P.Exc1.tauSyn = P.tau_exc;

P.Exc2.a = 0.01;
P.Exc2.b = 0.2;
P.Exc2.c = -55;
P.Exc2.d = 2;
P.Exc2.I0 = 6;
P.Exc2.tauSyn = P.tau_exc;


g_exc1_inh = 0.02;
p_exc1_inh = 0.3;

g_exc2_exc1 = 0.02;
p_exc2_exc1 = 0.1*0;

g_exc2_exc2 = 0.005;
p_exc2_exc2 = 0.1;

g_inh_exc2 = 0.02;
p_inh_exc2 = 0.1;


P.G_exc1_inh = nCellInh * p_exc1_inh * g_exc1_inh;
P.G_exc2_exc1 = nCellExc1 * p_exc2_exc1 * g_exc2_exc1;
P.G_exc2_exc2 = nCellExc2 * p_exc2_exc2 * g_exc2_exc2;
P.G_inh_exc2 = nCellExc2 * p_inh_exc2 * g_inh_exc2;


% P.g = nCell * pCon * gCon * wCon;
% 
% 
% 
% 
%% Solve 3-population reduced IZH model


ZZ = odeset();
Init = [-70; -5; 0.0];
[tRed, xRed] = ode23s(@ReboundNetwork,[0,tMax],[Init; Init; Init],ZZ,P);

figure;
plot(tRed, xRed(:, 1:3:end));
title('V')

figure;
plot(tRed, xRed(:, 2:3:end));
title('u')

figure;
plot(tRed, xRed(:, 3:3:end));
title('s')




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

% I0 = P.I(0);

% --- Populations ---


AddPopulation(...
    'Name','Inh',...
    'nCell', nCellInh, ...
    'Type','Izhikevich',... 
    'a','Normal', [P.Inh.a, 0.001],...
    'b','Normal', [P.Inh.b, 0.01],...
    'c','Normal', [P.Inh.c, 1],...
    'd','Normal', [P.Inh.d, 0.1],...
    'I','Normal', [P.Inh.I0, 0.2],...
    'V','Normal', [-70, 3],...
    'w','Normal', [-5, 5],...
    'Position',rand(nCellInh,3));

AddPopulation(...
    'Name','Exc1',...
    'nCell', nCellExc1, ...
    'Type','Izhikevich',... 
    'a','Normal', [P.Exc1.a, 0.001],...
    'b','Normal', [P.Exc1.b, 0.01],...
    'c','Normal', [P.Exc1.c, 1],...
    'd','Normal', [P.Exc1.d, 0.1],...
    'I','Normal', [P.Exc1.I0, 0.0],...
    'V','Normal', [-70, 3],...
    'w','Normal', [-10, 5],...
    'Position',rand(nCellExc1,3));


AddPopulation(...
    'Name','Exc2',...
    'nCell', nCellExc2, ...
    'Type','Izhikevich',... 
    'a','Normal', [P.Exc2.a, 0.001],...
    'b','Normal', [P.Exc2.b, 0.01],...
    'c','Normal', [P.Exc2.c, 1],...
    'd','Normal', [P.Exc2.d, 0.1],...
    'I','Normal', [P.Exc2.I0, 0.2],...
    'V','Normal', [-70, 3],...
    'w','Normal', [-10, 5],...
    'Position',rand(nCellExc2,3));


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
    'From','Inh',...
    'To',{'Exc1'},...
    'Type','Exponential',...
    'Tau', P.tau_inh, 'E', P.E_inh, 'g', g_exc1_inh,...
    'Connections','Generate','Probability', p_exc1_inh,'Weight', 1, ...
    'Delay','Function',0);

AddConnectivity(...
    'From','Exc1',...
    'To',{'Exc2'},...
    'Type','Exponential',...
    'Tau', P.tau_exc, 'E', P.E_exc, 'g', g_exc2_exc1,...
    'Connections','Generate','Probability', p_exc2_exc1,'Weight', 1, ...
    'Delay','Function',0);
   
AddConnectivity(...
    'From','Exc2',...
    'To',{'Exc2'},...
    'Type','Exponential',...
    'Tau', P.tau_exc, 'E', P.E_exc, 'g', g_exc2_exc2,...
    'Connections','Generate','Probability', p_exc2_exc2,'Weight', 1, ...
    'Delay','Function',0);
   
AddConnectivity(...
    'From','Exc2',...
    'To',{'Inh'},...
    'Type','Exponential',...
    'Tau', P.tau_exc, 'E', P.E_exc, 'g', g_inh_exc2,...
    'Connections','Generate','Probability', p_inh_exc2,'Weight', 1, ...
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
%     system('.\VerdandiLite_v1_1\VerdandiLite_WIN32.exe');
else
    error('No binaries available for VerdandiLite. Please compile C++ source files and add modify these Matlab lines.')
end


toc

SkuldOut



%% Do basic data analysis on results

% Obtain synaptic currents

% SP = load('Spikes.txt.');
% [tSpikes, rSpikes] = AnalyzeSpikes(SP, P.tauSyn);
% 
% hold on
% plot(tRed, xRed(:, 3), 'r')
% 
% 
% 
% RasterIDs = 20:20:nCell;
% % CellSpikes = cell(numel(RasterIDs),1);
% 
% figure;
% ax = subplot(3,1,2);
% hold off
% for iCell = RasterIDs
%     IDX = SP(:,2)==iCell;
%     CellSpikes = SP(IDX,1)';
%     plot(CellSpikes, iCell*ones(size(CellSpikes)), '.k', 'MarkerSize', 10);
%     hold on
% end
% ylabel('Cell ID');
% % set(ax, 'Ylabel', 'Cell ID');
% set(ax, 'XTickLabel', {});
% 
% subplot(3,1,3)
% hold off
% plot(tSpikes, nCell*rSpikes, 'b')
% hold on
% plot(tRed, nCell*xRed(:, 3), 'r')
% ylabel('Synapses');
% legend('Network', 'Reduction')
% 
% 
% figure;
% subplot(2,2,1)
% plot(xRed(:,1), xRed(:,2));
% xlabel('v');
% ylabel('u');
% 
% subplot(2,2,3)
% plot(xRed(:,1), xRed(:,3));
% xlabel('v');
% ylabel('s');
% 
% subplot(2,2,2)
% plot(xRed(:,3), xRed(:,2));
% xlabel('s');
% ylabel('u');
% 

SP = load('Spikes.txt');
% [tSpikes, rSpikes] = AnalyzeSpikes(SP, P.tauSyn);

% hold on
% plot(tRed, xRed(:, 3), 'r')

nCell = [Network.Population(:).nCell];
tauCell = [P.tau_inh, P.tau_exc, P.tau_exc];
cCell = cumsum([0, nCell]);

nRaster = 20;

nCat = numel(nCell);
hFig = figure;
hAx = zeros(nCat,2);
for iCat = 1:nCat
    % plot raster
    figure(hFig);
    hAx(iCat, 1) = subplot(nCat,2,2*(iCat-1)+1);
    
    for iRaster = 1:nRaster
        IDX = SP(:,2)==cCell(iCat)+iRaster-1;
        CellSpikes = SP(IDX,1)';
        plot(CellSpikes, iRaster*ones(size(CellSpikes)), '.k', 'MarkerSize', 10);
        hold on
    end
    
    IDX = (SP(:,2) >= cCell(iCat)) & (SP(:,2) < cCell(iCat+1));
    CatSpikes = SP(IDX,:);
    CatSpikes(:,2) = CatSpikes(:,2) - cCell(iCat);
    [tSpikes, rSpikes] = AnalyzeSpikes(CatSpikes, tauCell(iCat));

    figure(hFig);
    hAx(iCat, 2) = subplot(nCat,2,2*iCat);
    plot(tSpikes, nCell(iCat)*rSpikes, 'b')
    hold on
    plot(tRed, nCell(iCat)*xRed(:, 3*iCat), 'r');
    
end

set(hAx, 'XLim', [tMax-500, tMax]);
linkaxes(hAx(:), 'x');

set(hFig, 'UserData', P);
    
    

Skuld('SkuldSet.mat')