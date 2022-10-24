clear all;close all;clc;
Accorr=@(x)( abs(fftshift(ifft2(abs(fftshift(fft2(x))).^2))));
hux=@(u,m,n)([u(:,2:n)-u(:,1:n-1), zeros(m,1)]);
huy=@(u,m,n)([u(2:m,:)-u(1:m-1,:); zeros(1,n)]);
TVc=@(ux,uy)(sum(sum(sqrt(ux.*ux+uy.*uy))));
%I0= im2double((imread('..\SandPaper\48.TIF')));
dir1='20220719/';
dir2='20220719/';
enname='X_ray_speckle.tif';
namea=strcat(dir1,enname);
nameb=strcat(dir2,"sample.tif");
I0=im2double(imread(namea));
%I0=Ia(537:2814,135:2682);
[N1,N2] = size(I0);
Speckle_FT = fftshift(fft2((I0)));
T = zeros(N1,N2);
Filter_Length = 31;
T(ceil(N1/2)+(-Filter_Length:Filter_Length),ceil(N2/2)+(-Filter_Length:Filter_Length)) = 1;
Speckle_FT_LP = Speckle_FT.*T;
Speckle_LP = abs(ifft2(ifftshift(Speckle_FT_LP)));
Speckle_m = I0./Speckle_LP;

rng('default');
%load RawIm.mat;
%aut=Accorr(I0);
%figure();
%imshow(aut,[]);
%colormap hot;
%I=I0(1:1791,1:2000,1);
%%%

% [N1,N2] = size(I0);
% Speckle_FT = fftshift(fft2((I0)));
% T = zeros(N1,N2);
% Filter_Length = 31;
% T(ceil(N1/2)+(-Filter_Length:Filter_Length),ceil(N2/2)+(-Filter_Length:Filter_Length)) = 1;
% Speckle_FT_LP = Speckle_FT.*T;
% Speckle_LP = abs(ifft2(ifftshift(Speckle_FT_LP)));
% I0= I0./Speckle_LP;
%%%
I=I0;
a=max(max(I));
I=I/a;
I=I-min(I(:));
D=256;
phase0=rand(D,D);
phase0(phase0<0)=0;
phase0=0;
OTF=exp(2*pi*1i*phase0);
NNP=40;
N=7;
rois=zeros(D,D,N);
fims=zeros(D,D,N);
phase_s=zeros(D,D,N);
mfim=zeros(D,D,N);
objn=zeros(D,D,N);
for n=1:N
        a=floor(N1/4)+randi(50);
        b=floor(N2/4)+randi(50);
        rois(:,:,n)=I(a:a+D-1,b:b+D-1);
        fims(:,:,n)=fft2(rois(:,:,n));
        phase_s(:,:,n)=angle(fims(:,:,n));
        mfim(:,:,n)=abs(fims(:,:,n));
end
aut=Accorr(rois(:,:,4));
% figure();
% saut=aut(64:192,64:192);
% imshow(mat2gray(saut));
% colormap gray;

lbd=0.2;
beta=0.55;
betas=beta:-0.01:0;
OO_R=zeros(D,D,N);
for k=1:10
    for n=1:N
        for bets=betas
        FFT_O=mfim(:,:,n).*exp(1i*(phase_s(:,:,n)-angle(OTF)));
        O=fftshift(ifft2(FFT_O));
        OO=abs(DHIO(O,NNP,D,D));
        FFT_O=fft2(OO);
       phase2=phase_s(:,:,n)-angle(FFT_O);
       OTF=exp(1i*phase2);
       %%% TV constrain 
       OO=abs(fftshift(ifft2(fims(:,:,n)./OTF)));  
       OO=(1-bets)*OO+bets*TVC(OO,lbd,5);
        OO(OO<0.7)=0;
        %osnr=snr(OO(:));
        %disp(osnr);
        OO_R(:,:,n)=OO;
       FFT_O=fft2(OO);
       phase2=phase_s(:,:,n)-angle(FFT_O);
       OTF=exp(1i*phase2);
        end
       %%%
    end
end
%%
nameb='20220719/sample.tif';
name0='TV/';
im2=im2double(imread(nameb));
[x0,y0]=size(im2);
psf=zeros(x0,y0);
c0=fix(x0/2);
r0=fix(y0/2);

%figure(),imshow(im2,[]);
%imwrite(uint16(im2),"NewResult/RawFig.tif",'ColorSpace','icclab');
for n=1:N
    %figure();
    %nmap=jet(60);
    %imwrite(OO_R(:,:,n),name);
    psf0=OO_R(:,:,n);
    psf=newpsf(x0,y0,psf0);
    name=strcat('NewResult/Chip3',num2str(n),enname);
    %recon= deconvlucy(im2,psf,15);
    recon=decon_ttk(im2,psf,3e1);
    imwrite(uint16(recon),name,'ColorSpace','icclab');
    %imshow(recon,[])
    %colormap gray;
end
%%
%%%%

        
        
