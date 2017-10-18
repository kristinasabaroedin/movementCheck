% This script excludes participants based on the boxplot threshold of the FD values collapsed across participants and time

load ('/Users/kristinasabaroedin/Documents/Projects/genofcog/motion-control/cnp-fd.mat')

for i = 1:height(metadata)
	fdJenk = metadata.fdJenk{i};
	fdJenk_mean = metadata.fdJenk_m(i);

    % ------------------------------------------------------------------------------
    % Initial, gross movement exclusion
    % ------------------------------------------------------------------------------
	% 1) Exclude on mean rms displacement
			% Calculate whether subject has suprathreshold mean movement
		% If the mean of displacement is greater than 0.55 mm (Sattethwaite), then exclude
		if fdJenk_mean > 0.55
			exclude(i,1) = 1;
		else
			exclude(i,1) = 0;
		end	

	% ------------------------------------------------------------------------------
	% Stringent, multi criteria exclusion
	% ------------------------------------------------------------------------------

	if fdJenk_mean > 0.2
		mean_exclude(i,1) = 1;
	else
		mean_exclude(i,1) = 0;
	end	

	fdThr = 0.22;
	% Calculate whether subject has >20% suprathreshold spikes
	numVols = size(metadata.mov{1},1)-1;
	fdJenkThrPerc = round(numVols * 0.20);
	% If the number of volumes that exceed fdThr are greater than %20, then exclude
	if sum(fdJenk > fdThr) > fdJenkThrPerc
		sum_exclude(i,1) = 1;
	else
		sum_exclude(i,1) = 0;
    end

   
    
	% 3) Exclude on large spikes (>5mm)
	if any(fdJenk > 5)
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
	TR = 2;
	spikereg = GetSpikeRegressors(fdJenk,fdThr); % Spike regression exclusion
	numCVols = numVols - size(spikereg,2); % number of volumes - number of spike regressors (columns)
	NTime = (numCVols * TR)/60; % Compute length, in minutes, of time series data left after censoring
	if NTime < thresh;
		censoring_exclude(i,1) = 1;
	else
		censoring_exclude(i,1) = 0;
	end
		

end