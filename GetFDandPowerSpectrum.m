% Get Jenkinson's FD and Power Spectrum

% Define variables
Fs = 0.754; % This is the TR
T = 1/Fs;
numVols = 616;

subject = 'sub-023';

cd ~/Desktop
	 

mov = dlmread('prefiltered_func_data_mcf.par');
mov = mov(:,[4:6,1:3]);

% ------------------------------------------------------------------------------
% Compute fd (Jenkinson2002) (used by Satterthwaite2012)
% ------------------------------------------------------------------------------
% Get FD
fdJenk = GetFDJenk(mov, 50);

% ------------------------------------------------------------------------------
% Get frequency
% ------------------------------------------------------------------------------
[f P1 P2 freqA psdxA freqB psdxB] = PowerSpect(Fs,fdJenk);

% ------------------------------------------------------------------------------
% Get plots
% ------------------------------------------------------------------------------
PlotPowerSpect(subject,numVols,fdJenk,f,P1,P2,freqA,psdxA,freqB,psdxB);

fig = gcf;
set(fig,'PaperPositionMode','Auto')
print(fig,[subject,'_powerspect.bmp'],'-dbmp')