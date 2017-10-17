% Boxplot cutoff for a subject's framewise displacement

% ------------------------------------------------------------------------------
% Get fsl_motion_outliers threshold for fdJenk
% ------------------------------------------------------------------------------

    %display('Calculating FSL threshold')
	%percentile{idx(i),1} = prctile(fdJenk{idx(i)},75);
	%interquartile{idx(i),1} = iqr(fdJenk{idx(i)});
	%fdJenkFSLThr{idx(i),1} = percentile{idx(i),1} + interquartile{idx(i),1} * 1.5;