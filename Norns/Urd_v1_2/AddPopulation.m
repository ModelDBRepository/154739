function AddPopulation(varargin)

global Network

if(~isfield(Network,'Population'))
    iPop = 1;
else
    iPop = length(Network.Population) + 1;
end

C = varargin;

[n,e] = FindValue(C,'nCell','n',1);
if(e==0)
    Network.Population(iPop).nCell = n;
else
    error('nCell undefined for population');
end
if(iPop == 1)
    Network.Population(iPop).Offset = 0;
    Network.TargetsPerCell = cell(n,1);
else
    Network.Population(iPop).Offset = Network.Population(iPop-1).Offset + Network.Population(iPop-1).nCell;
    Network.TargetsPerCell = [Network.TargetsPerCell; cell(n,1)];
end



[s,e] = FindValue(C,'Name','s',1);
if(e>0)
    error('Population name not provided correctly')
end
Network.Population(iPop).Name = s;

[t,e] = FindValue(C,'Type','s',1);
switch(t)
    case('LeakyIntegrate')
        tID = 0;
        np = 4;
        ns = 1;
        pLabel = {'C','VRest','VThreshold','VReset'};
        sLabel = {'V'};
    case('Izhikevich')
        tID = 1;
        np = 5;
        ns = 2;
        pLabel = {'I','a','b','c','d'};
        sLabel = {'V','w'};
    case('Poisson')
        tID = 2;
        np = 1;
        ns = 1;
        pLabel = {'Lambda'};
        sLabel = {};
    otherwise
        error('System of unknown type')
end

Network.Population(iPop).Type = tID;
for ip = 1:length(pLabel)
    [p, e] = FindValue(C,pLabel{ip},'n',n);
    if(e > 0)
        error(['Error for parameter: ' pLabel{ip} ', error code: ' num2str(e)])
    end
    Network.Population(iPop).Param(:,ip) = p;
end
% Add zeros for the remaining parameters that were not required:
if(isfield(Network.Population(iPop),'Param'))
    Network.Population(iPop).Param = [Network.Population(iPop).Param, zeros(n,np-length(pLabel))];
else
    Network.Population(iPop).Param = zeros(n,np);
end


for is = 1:length(sLabel)
    [s, e] = FindValue(C,sLabel{is},'n',n);
    if(e > 0)
        error(['Error for state: ' sLabel{is}])
    end
    Network.Population(iPop).State(:,is) = s;
end
% Add zeros for the remaining state variables that were not required:
if(isfield(Network.Population(iPop),'State'))
    Network.Population(iPop).State = [Network.Population(iPop).State, zeros(n,ns-length(sLabel))];
else
    Network.Population(iPop).State = zeros(n,ns);
end

% Handle positions next:
pID = find(strcmp('Position',C));
mpID = find(strcmp('MakePosition',C));
% Check for non-unique definitions:
if(numel([pID, mpID]) == 0)
    error('No position input provided')
end
if(numel([pID, mpID])>1)
    error('Multiple position inputs provided')
end

% Position is given directly
if(~isempty(pID))
    if(numel(C)>pID)
        pos = C{pID+1};
        if(~isnumeric(pos))
            error('Positions must be in numeric format')
        end
        if(size(pos,1) ~= n)
            error('Number of positions must equal number of cells')
        end
        if(size(pos,2) > 3)
            warning('Number of dimensions exceeds 3. Latter columns are ignored')
            Network.Population(iPop).Position = pos(:,[1:3]);
        else
            d = size(pos,2);
            Network.Population(iPop).Position = [pos, zeros(n,3-d)];
        end
    else
        error('No argument provided for field ''Position''')
    end
end

    
    
    
    