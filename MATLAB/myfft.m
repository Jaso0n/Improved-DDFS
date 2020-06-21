function [P1,f]=myfft(s0,fs)
s0 = s0 / 2^15;
N = length(s0);
W = window(@kaiser,N,39);
x = s0 .* W;
Y = fft(x);
P2 = abs(Y/N);
P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
P1 = 20*log10(P1);
f = fs*(0:(N/2))/N * (1/fs);
end