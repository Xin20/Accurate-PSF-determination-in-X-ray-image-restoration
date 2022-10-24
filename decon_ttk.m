function im2=decon_ttk(im,psf,alpha)
[m,n]=size(im);
[m0,n0]=size(psf);
if (m~=m0)||( n~=n0)
    disp("im and psf are not same dimension");
end
%psf=creat_psf(sigma_x,sigma_y,m,n);
fim=fftshift(fft2(im));
otf=fftshift(fft2(psf));
D=abs(otf).^2+alpha*alpha;
bhat=conj(otf).*fim;
xhat=fftshift(ifft2(bhat./D));
im2=abs(xhat);
end


