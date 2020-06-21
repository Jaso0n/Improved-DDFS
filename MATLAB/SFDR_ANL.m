clc
clear
close all
%0 .000 0000 0000 0000
fo = 9*10^6;
fs = 1*10^8;
df = fs/2^32;
pcw = floor(fo/df);
% d0 = textread('NODITHER.dat','%s');
% d1 = textread('WITHDITHER.dat','%s');
d0 = textread('DDFS_DATA_NODITHER.dat','%s');
d1 = textread('DDFS_DATA_WITHDITHER.dat','%s');
d2 = textread('DDFS_DATA_TRADITION.dat','%s');

s0 = hex2decWithSign(d0(10:30000-5000),4);
s1 = hex2decWithSign(d1(10:30000-5000),4);
s2 = hex2decWithSign(d2(10:30000-5000),4);
sdr0 = sfdr(s0,fs);
sdr0 = num2str(sdr0,3);


sdr1 = sfdr(s1,fs);
sdr1 = num2str(sdr1,3);

sdr2 = sfdr(s2,fs);
sdr2 = num2str(sdr2,3);

[P1,f1]=myfft(s0,fs);
[P2,f2]=myfft(s1,fs);
[P3,f3]=myfft(s2,fs);

subplot(3,1,1)
plot(f1,P1+14,'b');
grid on
grid minor
titlename = strcat('A无抖动:','SFDR=',sdr0,'dB');
title(titlename)
ylabel('幅度(dB)');


subplot(3,1,2)

plot(f2,P2+14,'b');
grid on
grid minor
titlename = strcat('B有抖动:','SFDR=',sdr1,'dB');
title(titlename)
ylabel('幅度(dB)');


subplot(3,1,3)

plot(f3,P3+14,'b');
grid on
grid minor
titlename = strcat('C传统设计:','SFDR=',sdr2,'dB');
title(titlename)
ylabel('幅度(dB)');
xlabel('归一化频率');





