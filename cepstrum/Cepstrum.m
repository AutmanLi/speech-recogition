% ����
%   spPitchTrackCepstrum: Pitch Tracking via the Cepstral Method 
% ʹ��
%   [F0, T, C] = 
%     spPitchTrackCepstrum(x, fs, frame_length, frame_overlap, window, show)
% ����
%   ��ʱ����� F0�仯
% ����
%   x               ��СNx1.
%   fs              �����ʣ���λHz. 
%   [frame_length]  ����Ƭ�γ��ȣ�Ĭ��30��ms�� 
%   [frame_overlap] ����Ƭ���ص����֣�Ĭ���ص����ȵ�һ�롣
%   [window] (�ַ���)����'rectwin'��Ĭ�ϣ�����'hamming'  
%   [show]   �Ƿ񻭳�����Ĭ�� false
% ���
%   F0              1*k ��������Ƶ�ʣ�K ������Ƭ��������
%   T               1*k,ÿ������Ƭ���м��ֵ
%   [C]             M*K ����cepstrogram 

function [F0, T, C] = Cepstrum(x, fs, frame_length, frame_overlap, window, show)
 %% ��ʼ��
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

  %% �������
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
     % ��������
    subplot(2,1,1);
    t = (0:N-1)/fs;
    plot(t, x);
    legend('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([t(1) t(end)]);

    % ���� F0����
    subplot(2,1,2);
    plot(T,F0);
    legend('pitch track');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
end
