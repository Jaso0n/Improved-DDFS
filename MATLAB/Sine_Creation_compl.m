clc
clear
% N=2048;
N=4096;
x=(0:1/N:1-1/N)*pi*2;
%x=(0:1/N:1-1/N)*pi/2;

y1 = cos(x);
y2 = sin(x);

% Á¿»¯Îª16bit
qpath = quantizer('fixed','floor','saturate',[16,15]);
fix_y1 = 2^15*quantize(qpath,y1);
fix_y2 = 2^15*quantize(qpath,y2);

% fid = fopen('cosine_rom_data_8192.txt','w+');
fid = fopen('cosine_rom_data_4096_2_pi.txt','w+');
str1 = 'MEMORY_INITIALIZATION_RADIX=10;';
str2 = 'MEMORY_INITIALIZATION_VECTOR=';
fprintf(fid,'\t%s\n \t%s\n', str1,str2);
for i =1 : N
    if i == N
        fprintf(fid,'\t%d%c',fix_y1(i),';');
    else
        fprintf(fid,'\t%d%c\n',fix_y1(i),',');
    end
end
fclose(fid);