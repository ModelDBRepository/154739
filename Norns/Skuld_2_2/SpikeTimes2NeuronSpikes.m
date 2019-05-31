function SP = SpikeTimes2NeuronSpikes(SpikeTimes,nCell)
%   SP is cell array of length N. The i-th element contains a vector with as
%   elements the times where the i-th neuron spikes.

SP = cell(nCell,1);

for iCell = 1:nCell
    timeIDs = find(SpikeTimes(:,2)==iCell);
    SP{iCell} = SpikeTimes(timeIDs,1);
end