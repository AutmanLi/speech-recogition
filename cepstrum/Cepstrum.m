% 名称
%   spPitchTrackCepstrum: Pitch Tracking via the Cepstral Method 
% 使用
%   [F0, T, C] = 
%     spPitchTrackCepstrum(x, fs, frame_length, frame_overlap, window, show)
% 描述
%   在时域跟踪 F0变化
% 输入
%   x               大小Nx1.
%   fs              采样率，单位Hz. 
%   [frame_length]  声音片段长度，默认30（ms） 
%   [frame_overlap] 声音片段重叠部分，默认重叠长度的一半。
%   [window] (字符型)窗型'rectwin'（默认）或者'hamming'  
%   [show]   是否画出来，默认 false
% 输出
%   F0              1*k 包含基本频率，K 是声音片段数量。
%   T               1*k,每个声音片段中间的值
%   [C]             M*K 包含cepstrogram 

function [F0, T, C] = Cepstrum(x, fs, frame_length, frame_overlap, window, show)
 %% 初始化
 N = length(x);
 if ~exist('frame_length', 'var') || isempty(frame_length)
     frame_length = 30;
 end
 if ~exist('frame_overlap', 'var') || isempty(frame_overlap)
     frame_overlap = 20;
 end
 if ~exist('window', 'var') || isempty(window)
     window = 'hamming';
 end
 if ~exist('show', 'var') || isempty(show)
     show = 0;
 end
 nsample = round(frame_length  * fs / 1000);
 noverlap = round(frame_overlap * fs / 1000); 
 if ischar(window)
     window   = eval(sprintf('%s(nsample)', window)); % e.g., hamming(nfft)
 end

  %% 基音监测
 pos = 1; i = 1;
 while (pos+nsample < N)
     frame = x(pos:pos+nsample-1);
     C(:,i) = spCepstrum(frame, fs, window);
     F0(i) = spPitchCepstrum(C(:,i), fs);
     pos = pos + (nsample - noverlap);
     i = i + 1;
 end
 T = (round(nsample/2):(nsample-noverlap):N-1-round(nsample/2))/fs;

if show 
     % 画出波形
    subplot(2,1,1);
    t = (0:N-1)/fs;
    plot(t, x);
    legend('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([t(1) t(end)]);

    % 画出 F0跟踪
    subplot(2,1,2);
    plot(T,F0);
    legend('pitch track');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
end
