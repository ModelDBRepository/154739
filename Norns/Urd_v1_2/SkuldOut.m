function SkuldOut
% This script generates a Skuld preset file for the current network

global Network

% Open stream for cell positions
fPos = fopen('CellPositions.txt','w');


nType = length(Network.Population);
Preset.CellTypes = cell(nType,6);
for iType = 1:nType
    % Write CellTypes
    Preset.CellTypes{iType,1} = logical(1);
    Preset.CellTypes{iType,2} = Network.Population(iType).Name;
    Preset.CellTypes{iType,3} = Network.Population(iType).nCell;
    Preset.CellTypes{iType,4} = '-';
    Preset.CellTypes{iType,5} = 'o';
    Preset.CellTypes{iType,6} = sprintf('[%0.1g %0.1g %0.1g]',rand(3,1));
    
    % Append cell positions to file
    fprintf(fPos,'%g %g, %g\n', Network.Population(iType).Position');
    
    
end

fclose(fPos);


fConCnt = fopen('ConnectionCount.txt','w');
fConLst = fopen('ConnectionList.txt','w');
for iType = 1:nType
    nCell = Network.Population(iType).nCell;
    for iCell = Network.Population(iType).Offset+(1:nCell)
        fprintf(fConCnt,'%u\n',size(Network.TargetsPerCell{iCell},1));
        if(~isempty(Network.TargetsPerCell{iCell}))
            SynIDs = Network.TargetsPerCell{iCell}(:,1);
            CellIDs = Network.SynapseCellParents(SynIDs);
            Data = [CellIDs(:), Network.TargetsPerCell{iCell}(:,[2,3])];
            fprintf(fConLst,'%u\t%g\t%g\n',Data');
        end
    end
end

fclose(fConCnt);
fclose(fConLst);

Preset.FilePath{1} = fullfile(pwd, 'CellPositions.txt');
Preset.FilePath{2} = fullfile(pwd, 'ConnectionCount.txt');
Preset.FilePath{3} = fullfile(pwd, 'ConnectionList.txt');
Preset.ConnectionListFormat = 4;

Preset.RadioSelected = [2,1,2,1,1];

if(Network.OutputSp==1)
    Preset.FilePath{6} = fullfile(pwd, 'Spikes.txt');
    Preset.NumberBox{4} = 1;
    Preset.NumberBox{5} = 2;
    Preset.SpikeTimesOffset = logical(0);
    
    Preset.RadioSelected(4) = 3;
end
    
if(Network.OutputVm==1)    
    Preset.FilePath{5} = fullfile(pwd, 'Vm.txt');
    Preset.NumberBox{1} = 1000/Network.dt;
    Preset.NumberBox{2} = Network.nStep*Network.dt/1000;
    Preset.NumberBox{3} = 0;
    
    Preset.RadioSelected(4) = 2;
end


save('SkuldSet','Preset');

