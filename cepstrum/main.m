[x, fs] = wavread('record/zhusongkai.wav'); 
 % x = wgn(1, 1000, 2); fs = 16000;
 %c = spCepstrum(x, fs, 'hamming', 'plot');
 [F0, T, R] = Cepstrum(x, fs, 30, 20, [], 'plot');