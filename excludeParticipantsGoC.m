% This script does exactly the same as excludeParticipants.m
% The only difference is that this script opens up motion parameters file first and
% computes FD; while excludeParticipants.m takes in data from a matlab structure

%datadir = '/Users/kristinasabaroedin/Documents/Projects/genofcog/motion-control/mc_par/';
datadir = '/Users/kristinasabaroedin/Documents/Projects/Michelle_MotionParams/';

cd(datadir)
%fileID = fopen('goc_subs.txt');
fileID = fopen('sns-rsfmri-subs.txt');
ParticipantIDs = textscan(fileID,'%s');
ParticipantIDs = ParticipantIDs{1};

% compute numsubs
numSubs = length(ParticipantIDs);

% ------------------------------------------------------------------------------
% Containers
% ------------------------------------------------------------------------------
mov = cell(numSubs,1);

fdJenk = cell(numSubs,1);
fdJenk_mean = zeros(numSubs,1);

for i = 1:numSubs
	% load motion para
	%mov{i} = dlmread([ParticipantIDs{i},'/prefiltered_func_data_mcf.par']);
    mov{i} = dlmread([ParticipantIDs{i},'_prefiltered_func_data_mcf.par']);
	mov{i} = mov{i}(:,[4:6,1:3]);
    
    numVols = size(mov{i},1);

	% Get FD
	fdJenk{i} = GetFDJenk(mov{i});
	% Calculate mean
	fdJenk_mean(i) = mean(fdJenk{i});

	% ------------------------------------------------------------------------------
    % Initial, gross movement exclusion
    % ------------------------------------------------------------------------------
	% 1) Exclude on mean rms displacement
	% Calculate whether subject has suprathreshold mean movement
	% If the mean of displacement is greater than 0.55 mm (Sattethwaite), then exclude
    % This value is halved for multiband data
	if fdJenk_mean(i) > 0.28
		exclude(i,1) = 1;
	else
		exclude(i,1) = 0;
	end	

	% ------------------------------------------------------------------------------
	% Stringent, multi criteria exclusion
	% ------------------------------------------------------------------------------

	if fdJenk_mean(i) > 0.2
		mean_exclude(i,1) = 1;
	else
		mean_exclude(i,1) = 0;
	end	

	fdThr = 0.12;
	% Calculate whether subject has >20% suprathreshold spikes
	fdJenkThrPerc = round(numVols * 0.20);
	% If the number of volumes that exceed fdThr are greater than %20, then exclude
	if sum(fdJenk{i} > fdThr) > fdJenkThrPerc
		sum_exclude(i,1) = 1;
	else
		sum_exclude(i,1) = 0;
    end
    
	% 3) Exclude on large spikes (>5mm)
    % This value is halved for multiband data
	if any(fdJenk{i} > 2.5)
		spike_exclude(i,1) = 1;
	else
		spike_exclude(i,1) = 0;
    end
     
    
    % If any of the above criteria is true of subject i, mark for exclusion
    if mean_exclude(i,1) == 1 | sum_exclude(i,1) == 1 | spike_exclude(i,1) == 1
        exclude(i,2) = 1;
    else
        exclude(i,2) = 0;
    end


    % threshold for exclusion in minutes
	thresh = 4;
	TR = 0.697;
    %TR = 0.754;
	spikereg = GetSpikeRegressors(fdJenk{i},fdThr); % Spike regression exclusion
	numCVols = numVols - size(spikereg,2); % number of volumes - number of spike regressors (columns)
	NTime = (numCVols * TR)/60; % Compute length, in minutes, of time series data left after censoring
	if NTime < thresh;
		censoring_exclude(i,1) = 1;
	else
		censoring_exclude(i,1) = 0;
	end
		
 end