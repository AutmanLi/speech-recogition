function Spectrum(Dt)
	for i = 1 : 20 : 200

		[N,M] = size(Dt);
		fs = 16000;
		samp = 0.02;
		dsamp = 0.01;
		fftN = 512;
		data = Dt((i-1)*samp*fs+1:i*samp*fs,1) + Dt((i-1)*samp*fs+1:i*samp*fs,2);
		% -- Amplitude ---
		figure(1);
		subplot(2,1,1);
		t = 0 : 1/fs : samp;
		% plot(t(1:length(t)-1)*1000, data(:,1));
		% xlabel('Time [ms]');
		% ylabel('Amplitude');
		% ylim([-0.5 0.5]);
		% --- Window Function ---
		ham_window = 0.54 - 0.46*cos(2*pi*[0:1/(length(data)-1):1]);
		wavdata = ham_window' .* data(:,1);
		% subplot(2,1,2);
		% plot(t(1:length(t)-1)*1000, wavdata);
		% xlabel('Time [ms]');
		% ylabel('Amplitude with window function');
		% ylim([-0.5 0.5]);

		% --- Derive spectrum ---
		% FFT
		dft = fft(wavdata, fftN);
		Pdft = (real(dft).^2 + imag(dft).^2);
		fscale = linspace(0, fs, fftN);
		% figure(2);
		% subplot(2,1,1);
		% plot(fscale(1:fftN/2), Pdft(1:fftN/2));
		% xlabel('Frequency [Hz]');
		% ylabel('Power spectrum');
		% xlim([0 5000])
		% --- Plot logarithm scale ---
		Pdft_log = log10(abs(dft).^2);
		% subplot(2,1,2);
		% plot(fscale(1:fftN/2), Pdft_log(1:fftN/2));
		% xlabel('Frequency [Hz]');
		% ylabel('Logarithm power spectrum [dB]');
		% xlim([0 5000]);

		% --- Cepstrum analysis ---
		cps = real(ifft(Pdft_log));
		quefrency = linspace(0, samp, samp*fs);
		figure(3);
		subplot(2,1,1);
		plot(quefrency(1:fftN/2)*1000, cps(1:fftN/2));
		xlabel('Quefrency [ms]');
		ylabel('Power cepstrum');
		hold on;
		% plot([0 quefrency(fftN/2)], [ 0.1  0.1], 'c');
		% plot([0 quefrency(fftN/2)], [-0.1 -0.1], 'c');
		for x = 1 : fftN/2
			if abs( cps(x) ) > 0.1
				plot(quefrency(x)*1000,cps(x),'ro');
			end
		end
		ylim([-0.3 0.3]);
		cps_lif = cps;
		cps_lif(13:length(cps)-12) = 0;    % Liftering
		% Power spectrum after liftering
		dftSpc = fft(cps_lif, fftN);
		AdftSpc = abs(10 .^ dftSpc);    % LogAmp to Amp
		PdftSpc = AdftSpc.^2;
		subplot(2,1,2);
		plot(fscale(1:fftN/2), PdftSpc(1:fftN/2));
		xlabel('Frequency [Hz]');
		ylabel('Power spectrum');
		xlim([0 5000]);
		% ylim([0 1]);

		pause

	end
end