
datadir = '/Users/kristinasabaroedin/Documents/Projects/genofcog/motion-control/mc_par/';

cd(datadir)
fileID = fopen('goc_subs.txt');
ParticipantIDs = textscan(fileID,'%s');
ParticipantIDs = ParticipantIDs{1};

% compute numsubs
numSubs = length(ParticipantIDs);

for i = 1:numSubs
	% load motion para
	mov = dlmread([ParticipantIDs{i},'/prefiltered_func_data_mcf.par']);
	mov = mov(:,[4:6,1:3]);
	% Get FD
	fdJenk{i} = GetFDJenk(mov);
	% get threshold of each subject
	percentile{i} = prctile(fdJenk{i},75);
	interquartile{i} = iqr(fdJenk{i});
	thr{i} = percentile{i} + (interquartile{i} * 1.5);
end