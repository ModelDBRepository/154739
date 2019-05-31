function [t, RatesC] = AnalyzeSpikes(SP, alpha, varargin)
% Optional argument can be handle to axes in which result should be plotted

SP(:,2) = SP(:,2)+1;

nCell = max(SP(:,2));
tMax = 100*round(max(SP(:,1))/100);

CellSpikes = cell(nCell,1);

for iCell = 1:nCell
    IDX = SP(:,2)==iCell;
    
    CellSpikes{iCell} = SP(IDX,1)';
end

xRes = nCell;
tRes = 1;

Rates = zeros(nCell/xRes, tMax/tRes);
tBins = (tRes/2):tRes:tMax;

for iX = 1:(nCell/xRes)
    Rates(iX,:) = hist([CellSpikes{xRes*(iX-1)+(1:xRes)}],tBins);
end
Rates=Rates/(xRes); % Factor 2 comes from size of domain

EventShape = exp(-tRes*(0.5:40)/alpha);
EventShape = [0*EventShape(2:end), EventShape];
% RatesC = conv2([1, 2, 1]/4,EventShape, Rates, 'same');
RatesC = conv(Rates,EventShape, 'same');

if(~isempty(varargin))
    if(ishandle(varargin{1}))
        axes(varargin{1});
    else
        figure;
    end
else
    figure;
end

t = tRes*(1:tMax/tRes);

if(length(varargin)==2)    
    plot(t,RatesC,varargin{2});
else
    plot(t,RatesC);
end


% % simplified testing code
% SP(:,2) = SP(:,2)+1;
% 
% nCell = max(SP(:,2));
% tMax = 100*round(max(SP(:,1))/100);
% 
% CellSpikes = cell(nCell,1);
% 
% for iCell = 1:nCell
%     IDX = find(SP(:,2)==iCell);
%     
%     CellSpikes{iCell} = SP(IDX,1)';
% end
% 
% xRes = 1;
% tRes = 3;
% 
% Rates = zeros(nCell/xRes, tMax/tRes);
% tBins = (tRes/2):tRes:tMax;
% 
% for iX = 1:(nCell/xRes)
%     Rates(iX,:) = hist([CellSpikes{xRes*(iX-1)+(1:xRes)}],tBins);
% end
% Rates=Rates/(xRes); % Factor 2 comes from size of domain
% 
% EventShape = exp(-tRes*(0.5:20)/alpha);
% RatesC = conv(Rates, EventShape, 'same');
% % RatesC = conv2(1,EventShape, Rates, 'full');
% 
% figure;
% plot(tRes*(1:tMax/tRes),RatesC);
