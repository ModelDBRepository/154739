function SP = Vm2NeuronSpikes(Vm,thres,SampRate)
% SP = SpikeTimes(Vm) returns the spike times of the neurons in Vm.
%   The columns of Vm represents the Vm time series of N neurons.
%   SP is cell array of length N. The i-th element contains a vector with as
%   elements the times where the times where the i-th neuron first crosses
%   thres.
nCell = size(Vm,2);
SP = cell(nCell,1);

for iCell = 1:nCell
    temp = find(Vm(:,iCell) > thres);
    d = diff(temp);
    ids = find(d==1);
    temp(ids+1) = [];
    SP{iCell} = temp/SampRate;
end