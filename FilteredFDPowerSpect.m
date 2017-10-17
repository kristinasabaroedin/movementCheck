function [f P1 P2 freqA psdxA freqB psdxB] = PowerSpect(Fs,x)
	% Power Spectral Density using FFT



	% =================================================================================
	% Single-sided amplitude spectrum of timeseries
	% =================================================================================

	N = length(x); % gets the timepoints
	Y = fft(x);

	% Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 
	% based on P2 and the even-valued signal length L.

	P2 = abs(Y/N);
	P1 = P2(1:N/2+1);
	P1(2:end-1) = 2*P1(2:end-1);

	% Define the frequency domain f and plot the single-sided amplitude spectrum P1
	f = Fs*(0:(N/2))/N;

	% plot(f,P1) 
	% ylim([0 max(p1)])
	% title('Single-Sided Amplitude Spectrum of FD – before filtering')
	% xlabel('f (Hz)')
	% ylabel('Power')

	% =================================================================================
	% Even-length input with sample rate
	% =================================================================================
	% Obtain the periodogram using fft. The signal is real-valued and has even length. 
	% Because the signal is real-valued, you only need power estimates for the positive 
	% or negative frequencies. In order to conserve the total power, multiply all frequencies 
	% that occur in both sets -- the positive and negative frequencies -- by a factor of 2. 
	% Zero frequency (DC) and the Nyquist frequency do not occur twice. Plot the result.

	N = length(x); % gets the timepoints
	xdftA = fft(x);
	xdftA = xdftA(1:N/2+1);
	psdxA = (1/(Fs*N)) * abs(xdftA).^2;
	psdxA(2:end-1) = 2*psdxA(2:end-1);
	freqA = 0:Fs/length(x):Fs/2;

	% plot(freqA,10*log10(psdxA))
	% grid on
	% title('FD Periodogram Using FFT')
	% xlabel('Frequency (Hz)')
	% ylabel('Power/Frequency')


	% =================================================================================
	% Input with normalised frequency
	% =================================================================================

	N = length(x);
	xdftB = fft(x);
	xdftB = xdftB(1:N/2+1);
	psdxB = (1/(2*pi*N)) * abs(xdftB).^2;
	psdxB(2:end-1) = 2*psdxB(2:end-1);
	freqB = 0:(2*pi)/N:pi;

	% plot(freqB/pi,10*log10(psdxB))
	% grid on
	% title('FD Periodogram Using FFT')
	% xlabel('Normalized Frequency (\times\pi rad/sample)') 
	% ylabel('Power/Frequency')

end
