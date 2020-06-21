clc
clear
%0 .000 0000 0000 0000
% sdr0 = [];
% fo = 9*10^6;
% fs = 1*10^8;
% df = fs/2^32;
% pcw = floor(fo/df);
load 20MHz_DI.mat
x = 1:length(sdr1);
scatter(x,sdr1,'k','filled')
title('抖动位数对SFDR的影响')
gca;
xlabel('抖动位数');
ylabel('SFDR(dB)')


% d0 = textread('DDFS_DATA_TEMP.dat','%s');
% s0 = hex2decWithSign(d0(10:25000),4);
% sdr0 = [sdr0 sfdr(s0,fs)]
% zer = [78.25 78.25 78.25 78.25];
% sdr1 =[zer sdr0];

% save('20MHz_DI.mat','sdr1')




% [P1,f1]=myfft(s0,fs);
% plot(f1,P1+14,'b');
% grid on
% grid minor
% titlename = strcat('SFDR=',sdr0,'dB');
% title(titlename)
% ylabel('幅度(dB)');