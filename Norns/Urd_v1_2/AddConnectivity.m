function AddConnectivity(varargin)

global Network

C = varargin;

% --- Identify Population IDs from Host population
fID = find(strcmp('From',C),1,'first');
if(isempty(fID))
    error('No ''From'' population(s) given')
end

if(ischar(C{fID+1}))
    HostPopID = find(strcmp(C{fID+1},{Network.Population(:).Name}));
    if(isempty(HostPopID))
        error('Host population could no be found')
    end
    if(numel(HostPopID)>1)
        error('Host population is non-unique')
    end
end

if(iscellstr(C{fID+1}))
    for i = 1:length(C{fID+1})
        id = find(strcmp(C{fID+1}{i},{Network.Population(:).Name}));
        if(isempty(id))
            error('Host population could no be found')
        end
        if(numel(id)>1)
            error('Host population is non-unique')
        end
        HostPopID(i) = id;
    end
end

if(~exist('HostPopID'))
    error('Host populations provided incorrectly')
end


% --- Identify Population IDs from Target population
tID = find(strcmp('To',C),1,'first');
if(isempty(tID))
    error('No ''To'' population(s) given')
end

if(ischar(C{tID+1}))
    TargetPopID = find(strcmp(C{tID+1},{Network.Population(:).Name}));
    if(isempty(TargetPopID))
        error('Target population could no be found')
    end
    if(numel(TargetPopID)>1)
        error('Target population is non-unique')
    end
end

if(iscellstr(C{tID+1}))
    for i = 1:length(C{tID+1})
        id = find(strcmp(C{tID+1}(i),{Network.Population(:).Name}));
        if(isempty(id))
            error('Target population could no be found')
        end
        if(numel(id)>1)
            error('Target population is non-unique')
        end
        TargetPopID(i) = id;
    end
end

if(~exist('TargetPopID'))
    error('Target populations provided incorrectly')
end


% --- Make synapses ---
[t,e] = FindValue(C,'Type','s',1);
switch(t)
    case('Delta')
        tID = 0;
        pLabel = {}; % Names of parameters
        ns = 0; % Number of state variables
    case('Exponential')
        tID = 1;
        pLabel = {'Tau','E','g'};
        ns = 1;
end
nTargetPop = length(TargetPopID);

if(~isfield(Network,'SynapsePopulation'))
    pOffset = 0;
    Network.SynapsePopulation(1).Offset = 0;
else
    pOffset = length(Network.SynapsePopulation);
end
if(~isfield(Network,'SynapseCellParents')) % such that SynapseCellParents(iSyn) returns the cell id of parent cell
    Network.SynapseCellParents = [];
end
TargetIDs = [];
for iPop = 1:nTargetPop
    Network.SynapsePopulation(pOffset+iPop).Type = tID;
    Network.SynapsePopulation(pOffset+iPop).Population = TargetPopID(iPop);
    
    nCell = Network.Population(TargetPopID(iPop)).nCell;
    
    if(pOffset+iPop == 1)
        Network.SynapsePopulation(1).Offset = 0;
    else
        Network.SynapsePopulation(pOffset+iPop).Offset = Network.SynapsePopulation(pOffset+iPop-1).Offset + ...
            Network.Population(Network.SynapsePopulation(pOffset+iPop-1).Population).nCell;
    end

    if(isempty(pLabel))
        Network.SynapsePopulation(pOffset+iPop).Param = zeros(nCell,0);
    end
    for ip = 1:length(pLabel)
        [p, e] = FindValue(C,pLabel{ip},'n',nCell);
        if(e > 0)
            error(['Error for parameter: ' pLabel{ip}])
        end
        Network.SynapsePopulation(pOffset+iPop).Param(:,ip) = p;
    end

%     for is = 1:length(sLabel)
%         [s, e] = FindValue(C,sLabel{is},'n',nCell);
%         if(e > 0)
%             error(['Error for state: ' sLabel{is}])
%         end
%         Network.Population(iPop).State(:,is) = s;
%     end
    
    Network.SynapsePopulation(pOffset+iPop).State = zeros(nCell,ns);
    
    TargetIDs = [TargetIDs, (1:nCell)+Network.SynapsePopulation(pOffset+iPop).Offset];
    
    Network.SynapseCellParents = [Network.SynapseCellParents, ...
        (1:Network.Population(TargetPopID(iPop)).nCell)+Network.Population(TargetPopID(iPop)).Offset];
    
end
    
% Obtain HostIDs from cells in host population
HostIDs = [];
for iPop = 1:length(HostPopID)
    HostIDs = [HostIDs, (1:Network.Population(HostPopID(iPop)).nCell)+Network.Population(HostPopID(iPop)).Offset];
end


% --- Determine what information about connections is given:
[c, e] = FindValue(C,'Connections','s',1);
switch(c)
    case('Matrix')
        MatrixConnections = 1;
        GenerateConnections = 0;
    case('Generate')
        MatrixConnections = 0;
        GenerateConnections = 1;
end

[t, e] = FindValue(C,'Delay','s',1);
switch(t)
    case('Matrix')
        MatrixDelays = 1;
        DistanceDelays = 0;
        ConstantDelays = 0;
        
        % Determine delay matrix
        fID = find(strcmp('Connections',C));
        m = C{fID+2};
        if(isnumeric(m))
            DelayMatrix = m;
        elseif(iscell(m))
            DelayMatrix = cell2mat(m);
        else
            error('Delay type Matrix requires a matrix or cell array')
        end

        % Check for size
        if(size(DelayMatrix,1) ~= length(TargetIDs) || size(DelayMatrix,2) ~= length(HostIDs))
            error('Size of delay matrix does not match number of cells')
        end        
        
    case('Function')
        MatrixDelays = 0;
        DistanceDelays = 1;
        ConstantDelays = 0;
        
        % Find delay function of connectivity:
        fID = find(strcmp('Delay',C),1,'first');
        d = C{fID+2};
        if(isnumeric(d) && numel(d)==1)
            Dfun = @(r) d*ones(size(r));
        elseif(isa(d,'function_handle'))
            Dfun = d;
        else
            error('Delay function for connections is not of type scalar or function handle')
        end
        
%     case('Constant')
%         MatrixDelays = 0;
%         DistanceDelays = 0;
%         ConstantDelays = 1;
%         
%         fID = find(strcmp('Delay',C),1,'first');
%         constD = C{fID+2};
%         if(~isscalar(constD))
%             error('Delay function for connections is not of type scalar or function handle')
%         end

        
    otherwise
        error('Delay type should be Matrix or Function')
end

if(GenerateConnections && MatrixDelays)
    error('Cannot generate connections and use Matrix-type delays')
end

% Check if distances between cells are needed:
if(GenerateConnections || DistanceDelays)
    HostPos = [];
    for iPop = 1:length(HostPopID)
        HostPos = [HostPos; Network.Population(HostPopID(iPop)).Position];
    end
    TargetPos = [];
    for iPop = 1:length(TargetPopID)
        TargetPos = [TargetPos; Network.Population(TargetPopID(iPop)).Position];
    end
    
    D = Dist2(TargetPos,HostPos');
end


if(GenerateConnections)
    % Find probability function
    fID = find(strcmp('Probability',C),1,'first');
    p = C{fID+1};
    if(isnumeric(p) && numel(p)==1)
        Pfun = @(r) p*ones(size(r));
    elseif(isa(p,'function_handle'))
        Pfun = p;
    else
        error('Probability function for connections is not of type scalar or function handle')
    end
        
    P = Pfun(D);
    % funky script to generate a mask to prevent self-connecting cells
    for i=1:length(HostPopID)
        for j=1:length(TargetPopID)
            if(HostPopID(i)==TargetPopID(j))
                cMask{j,i} = eye(Network.Population(HostPopID(i)).nCell);
            else
                cMask{j,i} = zeros(Network.Population(TargetPopID(j)).nCell,Network.Population(HostPopID(i)).nCell);
            end
        end
    end
    Mask = cell2mat(cMask);
        
    Con = rand(size(D))<(1-Mask).*P;
    
%     clear Mask cMask P
    
    % Find weight function of connectivity:
    fID = find(strcmp('Weight',C),1,'first');
    w = C{fID+1};
    if(isnumeric(w) && numel(w)==1)
        Wfun = @(r) w;
    elseif(isa(w,'function_handle'))
        Wfun = w;
    else
        error('Weight function for connections is not of type scalar or function handle')
    end

    WeightMatrix = spfun(Wfun,Con.*D);
    
end
    

if(MatrixConnections)
    fID = find(strcmp('Connections',C));
    m = C{fID+2};
    if(isnumeric(m))
        M = m;
    elseif(iscell(m))
        M = cell2mat(m);
    else
        error('Connection type Matrix requires a matrix or cell array')
    end
    
    % Check for size
    if(size(M,1) ~= length(TargetIDs) || size(M,2) ~= length(HostIDs))
        error('Size of connection matrix does not match number of cells')
    end
    
    WeightMatrix = sparse(M);
end


% Process all connections

[Targets, Hosts, Weights] = find(WeightMatrix);
HostCells = HostIDs(Hosts);
TargetSyns = TargetIDs(Targets);
if(DistanceDelays)
    IDs = find(WeightMatrix);
    R = D(IDs); % vector of distances, corresponding with above indices
    Tau = Dfun(R);
end

for iCon = 1:length(Targets)
    if(MatrixDelays)
        tau = DelayMatrix(Targets(iCon),Hosts(iCon));
    elseif(DistanceDelays)
        tau = Tau(iCon);
%     elseif(ConstantDelays)
%         tau = constD;
    end
        
    Network.TargetsPerCell{HostCells(iCon)}(end+1,:) = [TargetSyns(iCon), tau, Weights(iCon)];
end



