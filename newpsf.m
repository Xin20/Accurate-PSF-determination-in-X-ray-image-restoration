function psf= newpsf(m,n,psf0)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
psf=zeros(m,n);
D=40;
hDa=D/2-1;
hDb=D/2;

[D1,D2]=size(psf0);
% hD1=D1/2;
% hD2=D2/2;

ma=fix((m-D)/2);
mb=fix((n-D)/2);
[~,b]=max(psf0(:));
r0=mod(b,D1);
if r0==0
    r0=1;
end
c0=ceil(b/D1);

ca=r0-hDa;
cb=r0+hDb;
ra=c0-hDa;
rb=c0+hDb;
%%%%% 9 statement 
if (ca>0)&&(cb<=D1)&& (ra>0) && (rb<=D2)
   psf(ma:ma+D-1,mb:mb+D-1)=psf0(ca:cb,ra:rb);
   return;
else
    tempa=[psf0;psf0];
    temp=[tempa,tempa];
    if ca<=0
        ca=ca+D1;
        cb=cb+D1;
    end
    if ra<=0
        ra=ra+D2;
        rb=rb+D2;
    end
    psf(ma:ma+D-1,mb:mb+D-1)=temp(ca:cb,ra:rb);
    return;
end 

% end
% if ca<=0 
%     temp=[psf0;psf0];
%     ca=ca+D1;
%     cb=cb+D1;    
%     if ra<=0
%         tempb=[fliplr(temp),temp];
%         ra=ra+D2;
%         rb=rb+D2;
%         psf(ma:ma+D-1,mb:mb+D-1)=tempb(ca:cb,ra:rb);
%         return;
%     else
%         if rb>D2
%             tempb=[temp,fliplr(temp)];
%             psf(ma:ma+D-1,mb:mb+D-1)=tempb(ca:cb,ra:rb);
%             return;
%         else
%             psf(ma:ma+D-1,mb:mb+D-1)=temp(ca:cb,ra:rb);
%             return;
%         end
%     end
% else
%     if cb>D1
%         temp=[psf0;flipud(psf0)];
%         
%     else
%         
%     end
% end

        
end

