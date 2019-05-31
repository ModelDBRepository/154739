clear all

addpath 'Skuld_2_2' 'Urd_v1_2' 'VerdandiLite_v1_0'

global Network

disp('Preparing simulations')
tic 

% --- Time integration ---

Network.dt = 0.1; % Integration step (in ms)
Network.nStep = 10000; % Number of time steps

Network.OutputVm = 1; % 1=Output membrane potentials to Vm.txt, 0=no such output
Network.OutputSp = 1; % 1=Output spike times to Spikes.txt, 0=no such output

fInit = fopen('Inits.txt','w');
fprintf(fInit,'%u\t%g\n%u\t%u',Network.nStep,Network.dt,Network.OutputVm,Network.OutputSp);
fclose(fInit);



% --- Populations ---
AddPopulation(...
    'Name','Ecells',...
    'nCell', 50, ...
    'Type','LeakyIntegrate',... 
    'C', 15,...
    'VRest', -64,...
    'VThreshold', 'Normal', [-63,1],...
    'VReset', -75,...
    'V','Normal',[-65, 1],...
    'Position',rand(50,3));

AddPopulation(...
    'Name','Icells',...
    'nCell', 10, ...
    'Type','LeakyIntegrate',... 
    'C', 8,...
    'VRest', 'Normal',[-70, 1],...
    'VThreshold', -60,...
    'VReset', -80,...
    'V','Normal',[-70, 4],...
    'Position',rand(10,3));

% --- Connections ---    
AddConnectivity(...
    'From','Ecells',...
    'To',{'Ecells','Icells'},...
    'Type','Exponential',...
    'Tau',4,'E',0,'g',0.02,...
    'Connections','Generate','Probability',0.5, 'Weight', @(r) 1+rand(size(r)), ...
    'Delay','Function',@(r) r+1);
   
AddConnectivity(...
    'From','Icells',...
    'To',{'Ecells','Icells'},...
    'Type','Exponential',...
    'Tau',10,'E',-80,'g',0.2,...
    'Connections','Generate','Probability',0.2, 'Weight', @(r) 1+rand(size(r)), ...
    'Delay','Function',@(r) r+2);


WriteCells;
WriteConnectivity;

toc
disp('Running simulations')
tic 


if(ismac)
    system('VerdandiLite_v1_0/VerdandiLite_OSX');
elseif(ispc)
    system('VerdandiLite_v1_0\VerdandiLite_WIN32.exe');
else
    error('No binaries available for VerdandiLite. Please compile C++ source files and add modify these Matlab lines.')
end


toc

SkuldOut
Skuld('SkuldSet.mat')