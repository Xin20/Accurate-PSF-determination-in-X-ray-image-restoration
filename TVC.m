function [u, w1,w2] = ...
      TVC(f,lbd,NIT)

[m,n]=size(f);                %get the image's   size
hux=@(u,m,n)([u(:,2:n)-u(:,1:n-1), zeros(m,1)]);
huy=@(u,m,n)([u(2:m,:)-u(1:m-1,:); zeros(1,n)]);
w1=zeros(m,n);
w2=zeros(m,n);

u  = f;
ux =hux(u,m,n);% [u(:,2:n)-u(:,1:n-1), zeros(m,1)];
uy = [u(2:m,:)-u(1:m-1,:); zeros(1,n)];

for itr=1:NIT
  tau = 0.2 + 0.08*itr;
  w1 = w1 - tau*lbd*ux; 
  w2 = w2 - tau*lbd*uy;

  wnorm= max(1, sqrt(w1.^2+w2.^2));
  w1 = w1./wnorm;
  w2 = w2./wnorm;
  DivW = ([w1(:,1),w1(:,2:n)-w1(:,1:n-1)] + [w2(1,:);w2(2:m,:)-w2(1:m-1,:)]); 

  theta = (0.5 - 5.0/(15.0+itr)) / tau;
  u= (1.0-theta)*u + theta*(f - (1/lbd)*DivW);   
  ux=hux(u,m,n);
  uy=huy(u,m,n);

end
end

