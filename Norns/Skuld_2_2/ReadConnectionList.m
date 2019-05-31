function [Matrix, Details] = ReadConnectionList(FileName,ConnectionCount,varargin)
% This script reads the network files
% Matrix is a nCell-by-nCell sparse matrix that contains an ConnectionID at
% field (i,j) when neuron i connects with neuron j.
% Details is a struct, containing fields Delay, Weight and Channel. Each is
% a vector with the length of the total connections in the network. The
% i-th field in these vectors corresponds with the value of the i-th
% connection, determined by the ConnectionID in Matrix.

Ascii = 0;
if(length(varargin)==0)
    Endian = 'n';
else
    if(isempty(varargin{1}))
        Endian = 'n';
    else
        if(strcmp(varargin{1},'a'))  % ASCII format
            Ascii = 1;
        else
            Endian = varargin{1};   % Specific Endian type for binary format
        end
    end
end

% Open file
LIST = fopen(FileName,'r');

nCell = length(ConnectionCount);

nConnection = sum(ConnectionCount);

I = zeros(nConnection,1);
J = zeros(nConnection,1);
Details.Delay = zeros(nConnection,1);
Details.Weight = zeros(nConnection,1);
Details.Channel = zeros(nConnection,1);

ConnectionID = 0;

if(Ascii == 0)  % Read binary file
    for iCell = 1:nCell
        for iConnection = 1:ConnectionCount(iCell)
            % Read fields from file:
            cellNo = fread(LIST,1,'ushort=>double',0,Endian)+1;
            channel = fread(LIST,1,'uchar=>double',1,Endian)+1;
            delay = fread(LIST,1,'ushort=>double',0,Endian)*1e-6;
            weight = fread(LIST,1,'ushort=>double',0,Endian)*(10/65535);

            if(cellNo>nCell)
                disp(cellNo)
                warning('Encountered cell outside range')
                error('Error reading network')
            end

            ConnectionID = ConnectionID + 1;
            I(ConnectionID) = iCell;
            J(ConnectionID) = cellNo;
            Details.Delay(ConnectionID) = delay;
            Details.Weight(ConnectionID) = weight;
            Details.Channel(ConnectionID) = channel;

        end
    end

    I = I(1:ConnectionID);
    J = J(1:ConnectionID);

else % Read ASCII file:
    
    Offset = 0;
    for iCell = 1:nCell
        Data = fscanf(LIST,'%f',[3,ConnectionCount(iCell)])';
        ids = Offset+(1:ConnectionCount(iCell));
        I(ids) = iCell;
        J(ids) = Data(:,1);
        Details.Delay(ids) = Data(:,2)/1000;
        Details.Weight(ids) = Data(:,3);
        
        Offset = Offset+ConnectionCount(iCell);
    end
end

Matrix = sparse(I,J,1:nConnection,nCell,nCell);

% Close file
fclose(LIST);