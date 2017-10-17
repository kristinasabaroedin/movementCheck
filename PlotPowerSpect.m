function [] = PlotPowerSpect(subject,numVols,fdJenk,f,P1,P2,freqA,psdxA,freqB,psdxB)

	% ------------------------------------------------------------------------------
	% Plot
	% ------------------------------------------------------------------------------
	FSize = 10;
	h1 = figure('color','w', 'units', 'centimeters', 'pos', [0 0 21 29.7], 'name',['FD power spectrum: ',subject]); box('on'); movegui(h1,'center');
	h2 = suptitle(['FD power spectrum:: ',subject]);
	pos = get(h2,'Position');
	set(h2,'Position',[pos(1)*1, pos(2)*0.5, pos(3)*1]);


	% ------------------------------------------------------------------------------
	% Plot FD
	% ------------------------------------------------------------------------------
	sp1 = subplot(4,2,1);
	pos1 = get(sp1,'Position');

	plot(fdJenk)
	hold on
	title('fdJenk','fontweight','bold')
	ylabel('mm')
	xlabel('time points')
	xlim([1 numVols])
	ylim([0 max(fdJenk)+(max(fdJenk)*.10)])
	set(sp1,'XTickLabel','');
	set(gca,'FontSize',FSize)

	% Add text to plot
	fdJenk_m = mean(fdJenk); % mean FD
	fdJenkMax = max(fdJenk);

	str1 = ['Mean = ',num2str(fdJenk_m,'%0.2f'),'mm. Max value of spike = ',num2str(fdJenkMax,'%0.2f'),'mm.'];
		
	yLimits = ylim;
	text(round(numVols*.05),yLimits(2) - yLimits(2)*.2,str1,... 
			'HorizontalAlignment','left',...
			'VerticalAlignment','middle',...
			'Color','black',...
			'FontSize', FSize)

	% overlay threshold line
	line([0 numVols],[0.2 0.2],'LineStyle','--','Color','k')


	% ------------------------------------------------------------------------------
	% Plot single-sided amplitude powerpectrum
	% ------------------------------------------------------------------------------
	sp2 = subplot(4,2,3);
	pos2 = get(sp2,'Position');

	plot(f,P1) 
	grid on
	ylim([0 max(P1)])
	title('Single-Sided Amplitude Spectrum of FD before filtering')
	xlabel('f (Hz)')
	ylabel('Power')

	set(gca,'FontSize',FSize)


	% ------------------------------------------------------------------------------
	% Plot scaled powerpectrum
	% ------------------------------------------------------------------------------
	sp3 = subplot(4,2,5);
	pos3 = get(sp3,'Position');

	plot(freqA,10*log10(psdxA))
	grid on
	title('Scaled FD Periodogram Using FFT')
	xlabel('Frequency (Hz)')
	ylabel('Power/Frequency')
	set(gca,'FontSize',FSize)

	% ------------------------------------------------------------------------------
	% Plot normalised powerpectrum
	% ------------------------------------------------------------------------------
	sp4 = subplot(4,2,7);
	pos4 = get(sp4,'Position');

	plot(freqB/pi,10*log10(psdxB))
	grid on
	title('Normalised FD Periodogram Using FFT')
	xlabel('Normalized Frequency (\times\pi rad/sample)') 
	ylabel('Power/Frequency')
	set(gca,'FontSize',FSize)

	% ------------------------------------------------------------------------------
	% Sizing
	% ------------------------------------------------------------------------------
	% [left bottom width height]
	set(sp1,'Position',[pos1(1)*.6, pos1(2)*1, pos1(3)*2.5, pos1(4)*1]);
	set(sp2,'Position',[pos2(1)*.6, pos2(2)*1, pos2(3)*2.5, pos2(4)*1]);
	set(sp3,'Position',[pos3(1)*.6, pos3(2)*0.95, pos3(3)*2.5, pos3(4)*1]);
	set(sp4,'Position',[pos4(1)*.6, pos4(2)*0.6, pos4(3)*2.5, pos4(4)*1]);

end