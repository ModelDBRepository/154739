function WriteCells

global Network

f = fopen('CellsIn.txt','w');

nPop = length(Network.Population);
fprintf(f,'%u\n',nPop);

for iPop = 1:nPop
    fprintf(f,'%u\t%u\n',Network.Population(iPop).Type, Network.Population(iPop).nCell);
end

for iPop = 1:nPop
    for iCell = 1:Network.Population(iPop).nCell
        fprintf(f,'%g\t',[Network.Population(iPop).Param(iCell,:), Network.Population(iPop).State(iCell,:)]);
        fprintf(f,'\n');
    end
end




fclose(f);