% 名称
%   spCepstrum 
% 用法
%   [c, y] = spCepstrum(x, fs, window, show)
% 面述
%   一个信号的倒谱
% 输入
%   x        N*1的向量用于容纳声音信号
%   fs       采样频率
%   [window] (字符型)窗型'rectwin'（默认）或者'hamming'  
%   [show]   是否画出来，默认 false
% OUTPUTS
%   c        N*1的倒谱信息。
%   [y]      N*1的傅里叶响应。
function [c, y] = spCepstrum(x, fs, window, show)
 %% 初始化
 N = length(x);
 x = x(:); % 确保一下是纵向量
 if ~exist('show', 'var') || isempty(show)
     show = 0;
 end
 if ~exist('window', 'var') || isempty(window)
     window = 'rectwin';
 end
 if ischar(window);
     window = eval(sprintf('%s(N)', window)); % hamming(N)
 end

 %% 窗形信号的傅里叶变换
 x = x(:) .* window(:);
 y = fft(x, N);

 %% 倒谱是log谱的 IDFT（或者 DFT）
 c = ifft(log(abs(y)+eps));

 if show
     ms1=fs/1000; % 1ms. 声音的最大 FX（1000Hz）
     ms20=fs/50;  % 20ms.  50Hzs声音最小 FX(50Hz)

     %% 画出波形
     t=(0:N-1)/fs;        % 采样次数
     subplot(2,1,1);
     plot(t,x);
     legend('Waveform');
     xlabel('Time (s)');
     ylabel('Amplitude');

     %% 画出1ms (=1000Hz)到20ms (=50Hz)的倒谱
     %% DC 部分 c(0) 太大
     q=(ms1:ms20)/fs;
     subplot(2,1,2);
     plot(q,abs(c(ms1:ms20)));
     legend('Cepstrum');
     xlabel('Quefrency (s) 1ms (1000Hz) to 20ms (50Hz)');
     ylabel('Amplitude');
 end
end
