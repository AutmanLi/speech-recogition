% ����
%   spCepstrum 
% �÷�
%   [c, y] = spCepstrum(x, fs, window, show)
% ����
%   һ���źŵĵ���
% ����
%   x        N*1�������������������ź�
%   fs       ����Ƶ��
%   [window] (�ַ���)����'rectwin'��Ĭ�ϣ�����'hamming'  
%   [show]   �Ƿ񻭳�����Ĭ�� false
% OUTPUTS
%   c        N*1�ĵ�����Ϣ��
%   [y]      N*1�ĸ���Ҷ��Ӧ��
function [c, y] = spCepstrum(x, fs, window, show)
 %% ��ʼ��
 N = length(x);
 x = x(:); % ȷ��һ����������
 if ~exist('show', 'var') || isempty(show)
     show = 0;
 end
 if ~exist('window', 'var') || isempty(window)
     window = 'rectwin';
 end
 if ischar(window);
     window = eval(sprintf('%s(N)', window)); % hamming(N)
 end

 %% �����źŵĸ���Ҷ�任
 x = x(:) .* window(:);
 y = fft(x, N);

 %% ������log�׵� IDFT������ DFT��
 c = ifft(log(abs(y)+eps));

 if show
     ms1=fs/1000; % 1ms. ��������� FX��1000Hz��
     ms20=fs/50;  % 20ms.  50Hzs������С FX(50Hz)

     %% ��������
     t=(0:N-1)/fs;        % ��������
     subplot(2,1,1);
     plot(t,x);
     legend('Waveform');
     xlabel('Time (s)');
     ylabel('Amplitude');

     %% ����1ms (=1000Hz)��20ms (=50Hz)�ĵ���
     %% DC ���� c(0) ̫��
     q=(ms1:ms20)/fs;
     subplot(2,1,2);
     plot(q,abs(c(ms1:ms20)));
     legend('Cepstrum');
     xlabel('Quefrency (s) 1ms (1000Hz) to 20ms (50Hz)');
     ylabel('Amplitude');
 end
end
