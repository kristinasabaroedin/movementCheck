% Boxplot cutoff for all subjects framewise displacement
% Collapsed across subjects and timepoints
% This script gets values for precomputed FD as variable
% So, to run this scrip, FD needs to be compited first and stored into a variable

% ------------------------------------------------------------------------------
% Get fsl_motion_outliers threshold for fdJenk
% ------------------------------------------------------------------------------
projdir = '/Users/kristinasabaroedin/Documents/Projects/Michelle_MotionParams/';
cd(projdir)
fileID = fopen('sns-rsfmri-subs.txt');
ParticipantIDs = textscan(fileID,'%s');
ParticipantIDs = ParticipantIDs{1};

% compute numsubs
numSubs = length(ParticipantIDs);


mov = cell(numSubs,1);

fdJenk = cell(numSubs,1);
fdJenk_mean = zeros(numSubs,1);

for i = 1:numSubs
	% load motion para
	mov{i} = dlmread([ParticipantIDs{i},'_prefiltered_func_data_mcf.par']);
	mov{i} = mov{i}(:,[4:6,1:3]);

	% Get FD
	fdJenk{i} = GetFDJenk(mov{i});
	exclusion = table(fdJenk);
	exclusion.Properties.VariableNames{1} = 'fdJenk';
end

x = cell2mat(exclusion.fdJenk);


display('Calculating FSL threshold')
percentile = prctile(x,75);
interquartile = iqr(x);
fdJenkFSLThr = percentile + (interquartile * 1.5);

boxplot(x)
title('SNS FD Distribution')

str1 = ['Median = ',num2str(median(x),'%0.2f'),'mm'];
str2 = ['75th percentile + 1.5*iqr = ',num2str(fdJenkFSLThr,'%0.2f'),'mm.'];
text(1,median(x),str1,'HorizontalAlignment','left','VerticalAlignment','middle','Color','black','FontSize', 10)
text(1,fdJenkFSLThr,str2,'HorizontalAlignment','left','VerticalAlignment','middle','Color','black','FontSize', 10)

