% ------------------------------------------------------------------------------
% This script simply gets the exclusion criteria based on 
% Siegel et al., 2016, Cerebral Cortex
% ------------------------------------------------------------------------------
% Steps
% 1 - Get FD -> GetFDJenk.m
% 2 - Transform them into hertz using FFT - This is just for visualisation
% 3 - Do a low pass filter of 0.3 Hz - to visualise the powerspectrum afterwards, can transform to hertz using FFT
% 4 - Count how many FD timepoints (after low pass filtered) exceed 0.025mm
% 5 - Exclude subjects with 30% of more timepoints  exceed 0.025mm


% ------------------------------------------------------------------------------
% Set paths
% ------------------------------------------------------------------------------
% projdir = '/projects/kg98/kristina/GenofCog/';
% sublist = [projdir,'/scripts/sublists/trial.txt'];
% datadir = [projdir,'datadir/derivatives/'];
% preprostr = '/prepro.feat/';
% mcstr = 'mc/';
% mname = 'prefiltered_func_data_mcf.par';
% t1str = '/anat/';

TR = 0.754;

% Number of timepoints (volumes) - length
L = 616;

subject = 'sub-023';

% ------------------------------------------------------------------------------
% Load in movement parameters from realignment
% ------------------------------------------------------------------------------
cd ~/Desktop

mov = dlmread('prefiltered_func_data_mcf.par');
mov = mov(:,[4:6,1:3]);

% ------------------------------------------------------------------------------
% Compute fd (Jenkinson2002) (used by Satterthwaite2012)
% ------------------------------------------------------------------------------
% Get FD
fdJenk = GetFDJenk(mov, 50);

% Calculate mean
fdJenk_m = mean(fdJenk);


% ------------------------------------------------------------------------------
% Low pass filter - Butterworth Filter
% ------------------------------------------------------------------------------

LowPass = 0.3;

% Frequency
Fs = 1/TR;
% Nyquist
Nq = Fs/2;

% Cutoff frequency
Wn = LowPass/Nq;

% Build filter – what is the appropriate filter order
% Siegel et al used 1 for temporal filtering
FiltOrder = 1;
[b,a] = butter(FiltOrder,Wn,'low');

% Apply filter; filtfilt applies the filter in both directions
filteredFD = filtfilt(b,a,fdJenk);

% ------------------------------------------------------------------------------
% Get frequency
% ------------------------------------------------------------------------------
[f P1 P2 freqA psdxA freqB psdxB] = FilteredFDPowerSpect(TR,filteredFD);

% ------------------------------------------------------------------------------
% Plot results
% ------------------------------------------------------------------------------

PlotFilteredFD(subject,L,filteredFD,f,P1,P2,freqA,psdxA,freqB,psdxB);

fig = gcf;
set(fig,'PaperPositionMode','Auto')
print(fig,[subject,'_filteredFD.bmp'],'-dbmp')
