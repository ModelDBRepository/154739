function [t, pd, mean, cv, tot_sp] = ISIdist(SpikeTimes,res,maxt)
% function returns the interspike interval distribution
% of a spike sequence and its mean and  coefficient of
% variation. 
%
% Input:
% SpikeTimes    = vector containing time (in s) of spikes
% res           = the resolution of the isi distribution [ms]      
% maxt          = maximal time interval to be taken into account [ms]
%
% Output:
% t             = matrix of time values for the ISIs. 
% pd            = corresponding probability distribution.
% mean          = mean isi 
% cv            = coefficient of variation of the isi distribution 

% Determine maxima above threshold for PPN and set up 0/1 point process representations.
% diff_tr=diff(Vm(1:end-1));                         % [ X(2)-X(1) ... X(n-1)-X(n-2) ]
% diff_tr_shift=diff(Vm(2:end));                     % [ X(3)-X(2) ... X(n)-X(n-1) ]
% tr_maxima=[ 0;(diff_tr>0).*(diff_tr_shift<=0);0 ]; % Boolean with maxima
% sp =(Vm>-20) .* tr_maxima;                    % Maxima above threshold  
% SpikeTimes = find(sp);

if(length(SpikeTimes) <= 1)
    msgbox({'Not enough spikes detected.','Cannot generate ISI-distribution'},'Skuld','warn');
    t = [];
    pd = [];
    mean = 0;
    cv = 0;
    tot_sp = 0;
    return;
end

%initializes the various variables
SpikeTimes = SpikeTimes*1000;     % To convert to ms
% isi_x      = (0:res:maxt)';
isi_x      = (res:res:maxt)'- res/2;

% Generate histogram 
isi   = diff(SpikeTimes);
isi_y = hist(isi,isi_x); 


%normalizes to probability per bin
tot_sp = sum(isi_y);                    % Neglect the first spike
isi_y  = (isi_y/tot_sp)';
 
%computes mean, covariance and cv of the isi distribution
mean = sum(isi_y.*isi_x);
cov  = sum(isi_y.*((isi_x-mean).^2)); 
std  = sqrt(cov);
cv   = std/mean;
pd   = isi_y;
t    = isi_x;