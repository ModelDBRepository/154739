function WriteConnectivity

global Network

fS = fopen('SynIn.txt','w');

nPop = length(Network.SynapsePopulation);
fprintf(fS,'%u\n',nPop);

for iPop = 1:nPop
    fprintf(fS,'%u\t%u\n',Network.SynapsePopulation(iPop).Type, Network.SynapsePopulation(iPop).Population-1);
end

fclose(fS);

for iPop = 1:nPop
    dlmwrite('SynIn.txt',[Network.SynapsePopulation(iPop).Param, Network.SynapsePopulation(iPop).State],'-append','delimiter','\t');
end


fC = fopen('ConIn.txt','w');

for iCell = 1:length(Network.TargetsPerCell)
    nCon = size(Network.TargetsPerCell{iCell},1);
    fprintf(fC,'%u\n',nCon);
%     for iCon = 1:nCon
%         fprintf(fC,'%g\t',Network.TargetsPerCell{iCell}(iCon,:)-[1 0 0]);
%         fprintf(fC,'\n');
% 
%     end

    Temp = Network.TargetsPerCell{iCell};
    if(~isempty(Temp))
        Temp(:,1) = Temp(:,1) - 1;
        fprintf(fC,'%g\t%g\t%g\n',Temp');
    end
end

fclose(fC);