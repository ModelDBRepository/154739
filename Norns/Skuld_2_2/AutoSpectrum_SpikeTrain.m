function [Pxx,f,Fig] =  AutoSpectrum_SpikeTrain(SpikeTimes,f_limit,Smoothing)
%
% Based on David M. Halliday 2008.
% Modified by M.A.J. Lourens and S. Visser
%
% Input:
%  SpikeTimes = Array of times (in sec) at which the neuron fires.
%  f_limit   = Upper limit of the frequency range to save
%  Smoothing  = 1 or 0. If Smoothing is 1 apply a smoothing

% Output:
%  Pxx          = Log sp1 spectrum.
%  f            = frequency in Hz.
% Seg_Num       + Number of segments used


% Transform SpikeTimes into 20kHz vector of zeros and ones.
samp_rate = 20000;
IDs = ceil(samp_rate*SpikeTimes);
pts_tot = max(IDs); % Number of samples in data set.
sp = zeros(pts_tot,1);
sp(IDs) = 1;

seg_size=2^14;            % DFT segment length (S).
seg_tot=fix(pts_tot/seg_size); % Number of complete segments (L).
samp_tot=seg_tot*seg_size;     % Number of samples to analyse: R=LT.


% Check input parameters
if (samp_tot<=0)
    msgbox({'Not enough spikes detected.','Cannot generate auto spectrum'},'Skuld','warn');
    Pxx = [];
    f = [];
    Fig = [];
    return;
end


% Create data matrices, S rows, L columns.
rd1 = reshape(sp(1:samp_tot),seg_size,seg_tot);
rd1 = rd1 - repmat(mean(rd1),seg_size,1);  % Subtract the mean from each segment

% Take DFT across columns/segments sp
fd1=fft(rd1); 
t_fac=2*pi*(seg_size*seg_tot);     % Normalization for weighted periodogram spectral estimates.
                         
f11=sum(abs(fd1.*fd1)/t_fac,2);    % Spectrum 1, Mag squared for spiketrain 1 autospectra.

% Spacing of Fourier frequencies in Hz.
deltaf=samp_rate/seg_size;        

% Reduce arrays to f_limit
aux = ceil(f_limit/deltaf)+1;
f11=f11(1:aux);

if Smoothing == 1
  % Apply smoothing using hanning filter.
  f11=han(f11);
  var_smooth=0.375; % Correction for variance of smoothed estimates, Bloomfield.
else  
  var_smooth=1;
end 

% Construct spectral output
f_index  = (2:aux)';   % Indexing for output, DC component not output.
f        = (f_index-1)*deltaf;  % frequencies in Hz.
Pxx      = log10(f11(f_index)); % Log spectrum sp1.
% Pxx  = f11(f_index)

% 95% Confidence limit for spectral estimates
Seg_Num=seg_tot/var_smooth;  % Effective no of segments (L')
Pmean = length(find(find(sp)<samp_tot))/(samp_tot*2*pi);
Sig_level = [Pmean 0.8512*sqrt(1/Seg_Num)]; 

Pxx  = f11(f_index)/Pmean;

% Plot AutoSpectrum
Fig = figure;
f_cl=[f(1),log10(Pmean);f_limit,log10(Pmean);
        f(1),log10(Pmean)+Sig_level(2);f_limit,log10(Pmean)+Sig_level(2)];
plot(f,Pxx,'b')
% plot(f,Pxx,'b',f_cl(1:2,1),f_cl(1:2,2),...
%         'k--',f_cl(3:4,1),f_cl(3:4,2),'k-');
axis([0,f_limit,-Inf,Inf]);
title('Auto Spectrum');
ylabel('|S(f)|')
xlabel('Frequency (Hz)')
end

%------------------------------------------------------------------------------
function [dat_out] = han(dat_in)
% function [dat_out] = han(dat_in);
%
% Function to smooth data vector using Hanning filter with coefficients: (1/4, 1/2, 1/4).
% End points smoothed using two point filter: (1/2, 1/2).

a=1;
b=[0.25;0.5;0.25];
dat_pts=length(dat_in);

% Smooth using function: filter.
dat_out=filter(b,a,dat_in);

% Shift one place to cancel out one sample delay in filter function.
dat_out=[dat_out(2:dat_pts);0];

% Smooth end points using two point filter: (1/2, 1/2).
dat_out(1)=0.5*(dat_in(1)+dat_in(2));
dat_out(dat_pts)=0.5*(dat_in(dat_pts)+dat_in(dat_pts-1));
end