% Get Jenkinson's FD and Power Spectrum

% Set paths
projdir = '/projects/kg98/kristina/GenofCog/';
sublist = [projdir,'/scripts/sublists/trial.txt'];
datadir = [projdir,'datadir/derivatives/'];
mcdir = '/prepro.feat/mc/';

% Define variables
Fs = 0.754; % This is the TR
T = 1/Fs;
numVols = 616;


outdir = ([datadir,'Plot_FD-PowerSpect']); 
if exist(outdir) == 0
	fprintf(1,'Initialising outdir\n')
	mkdir(outdir)
end

% ------------------------------------------------------------------------------
% Subject list
% ------------------------------------------------------------------------------
fileID = fopen(sublist);
ParticipantIDs = textscan(fileID,'%s');
ParticipantIDs = ParticipantIDs{1};

% compute numsubs
numSubs = length(ParticipantIDs);

for i = 1:numSubs

	subject = ParticipantIDs{i};

	cd(outdir)
	 
	% Load movement parameters
	mov = dlmread([datadir,subject,mcdir,'prefiltered_func_data_mcf.par']);
	mov = mov(:,[4:6,1:3]);

	% ------------------------------------------------------------------------------
	% Compute fd (Jenkinson2002) (used by Satterthwaite2012)
	% ------------------------------------------------------------------------------
	% Get FD - redius set to 50 as per Siegel et al 2016 paper
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
	close all

end