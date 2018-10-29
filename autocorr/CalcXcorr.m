% --- 计算 Xcorr ---

% 读取数据
%wavname1 = 'VoiceData/a_1.wav';
%wavname2 = 'VoiceData/i_1.wav';
%wavname3 = 'VoiceData/ka_1.wav';

wavname1 = 'record/lichuan.wav';
wavname2 = 'record/li.wav';
wavname3 = 'record/wangxiang.wav';
wavname4 = 'record/autman.wav';
wavname5 = 'record/zhusongkai.wav';

[data1,Fs1] = wavread(wavname1);
[data2,Fs2] = wavread(wavname2);
[data3,Fs3] = wavread(wavname3);
[data4,Fs4] = wavread(wavname4);
[data5,Fs5] = wavread(wavname5);

% 归一化数据
data1 = data1 / max(data1);
data2 = data2 / max(data2);
data3 = data3 / max(data3);
data4 = data4 / max(data4);
data5 = data5 / max(data5);


% 计算互相关函数
corr_data1 = xcorr(data1,data2);
%corr_data2 = xcorr(data2,data3);
corr_data3 = xcorr(data1,data3);
corr_data4 = xcorr(data1,data4);
corr_data5 = xcorr(data1,data5);
corr_data6 = xcorr(data1,data1);

figure(1);
subplot(5,1,1); plot(corr_data1); ylim([-400, 400]);
subplot(5,1,2); plot(corr_data3); ylim([-400, 400]);
subplot(5,1,3); plot(corr_data4); ylim([-400, 400]);
subplot(5,1,4); plot(corr_data5); ylim([-400, 400]);
subplot(5,1,5); plot(corr_data6); ylim([-400, 400]);