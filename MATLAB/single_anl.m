clc
clear
close all

fs = 1*10^8;
d0 = textread('DDFS_DATA_TEMP.dat','%s');

s0 = hex2decWithSign(d0(10:30000-5000),4);
s0 = s0/2^15;
sfdr(s0,fs);