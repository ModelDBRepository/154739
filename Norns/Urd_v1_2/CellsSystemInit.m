function CellsSystemInit
% function Cells = CellsSystemInit(Cells)
% This function initializes all the ODEs of the different cell types

global Cells Connectivity

for iType = 1:Cells.nType
    nCell = Cells.Type(iType).nCell;
    CurSystem = Cells.Type(iType).System;
    
    % Depending on the system, different state variables have to be made
    switch(CurSystem.Type)
        case('LIF')
            StateVars = {'V'};
%         case('Izhikevich')
%             StateVars = {'V','w'};
        otherwise
            error(['Undefined system type "' CurSystem.Type '" for population number ' num2str(iType)]);
    end
    
    % Make a vector for each state
    nState = length(StateVars);
%     [States{1:nState}] = deal(zeros(nCell,1));
    States = zeros(nCell,nState);

    % Set inits for each state
    for iState = 1:nState
        InitId = find(strcmp(StateVars{iState},{CurSystem.Inits(:).VarName}));
        if(numel(InitId) ~= 1)
            error(['Error while setting initial condition for state variable "' StateVars{iState} '": no or multiple definitions found']);
        end
        
        switch(CurSystem.Inits(InitId).Type)
            case('Constant')
                States(:,iState) = CurSystem.Inits(InitId).Value(1) * ones(nCell,1);
            case('Uniform')
                States(:,iState) = CurSystem.Inits(InitId).Value(1) + rand(nCell,1)*diff(CurSystem.Inits(InitId).Value(1:2));
            case('Gaussian')
                States(:,iState) = CurSystem.Inits(InitId).Value(1) + randn(nCell,1)*CurSystem.Inits(InitId).Value(2);
             case('LIFPhase')
                States(:,iState) = -(CurSystem.Inits(InitId).Value(1).^rand(nCell,1));

            otherwise
                error(['Initial condition of given type "' CurSystem.Inits(InitId).Type '" not supported']);
        end
    end
        
    % Add fields to the struct:
    Cells.Type(iType).System.nState = nState;
    Cells.Type(iType).System.StateVars = StateVars;
    Cells.Type(iType).System.State = States;
end
