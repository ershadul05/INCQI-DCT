clc
close all;
clear all;
Im = imread('P_gray.jpg');
%Im1=Im(1:512,1:512);
%Im1=Im(1:512,1:512,:);
%Im1=Im(:,:,3);
%Img= im2gray(Im);
%Img1=im2double(Im1);
Img2=Im;
[row1 col1]=size(Img2);
blocksize=8;

PSNR1=0;

BR=0;
Z=zeros(row1, col1);
for i=1:blocksize:row1
  for j=1:blocksize:col1

        W1=Img2(i:i+blocksize-1,j:j+blocksize-1);
        
        [row col]=size(W1);
        
        DCT=dct2(W1);
        
        q=70;
        
        B1q=round(DCT/q);
        absB1q= abs(B1q);
        Max=max(max(absB1q));
        MN=min(min(absB1q));
        
        %writematrix(absB1q, '128lena5_11072022.csv');
        
        [x y z]=find(absB1q);     
                      
        B_bin=dec2bin(x,3);
        B_bin=uint16(B_bin);
        B_bin=B_bin-48;
        B=numel(B_bin);
        C=dec2bin(y,3);
        C=uint16(C);
        C=C-48;
        C=numel(C);
        D=dec2bin(z,8);
        D=uint16(D);
        D=D-48;
        D=nnz(D);
        Sbit=D;
        accessory=D+B+C;
        BR=BR+(D+(B+C)*D+Sbit+accessory)/(1024*1024);

        B2=B1q.*q;
        
        
        RI1=idct2(B2);
        
        
        %figure 
        %I1=imshow(RI1,[0, 255]);
        
        Z(i:i+7,j:j+7)=RI1;

  end
end

PSNR1=CalculatePSNR(Img2, Z);

numofblockr=row1/blocksize;
numofblockc=col1/blocksize;

rposioflastblock=row1-blocksize;
cposioflastblock=col1-blocksize;

numofcolbit=numel(dec2bin(rposioflastblock))-numel(dec2bin(blocksize));
numofrowbit=numel(dec2bin(cposioflastblock))-numel(dec2bin(blocksize));
tbitr=numofblockr*numofblockc*(numofcolbit+numofrowbit)/(1024*1024);

BR=BR+tbitr
bpp=(BR*1024*1024)/(row1*col1)
PSNR1