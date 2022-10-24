function [output] = DHIO(input,NNP,m,n)
%DHIO 

input1 = abs(input(:));
s = sort(input1,'descend');
threshold = s (round(NNP));
a = 0.3; % 反馈系数，可调节。
support = zeros(m,n);
support(input1>=threshold)=1;
% support2 = zeros(m,n);
% support2((m-200)/2+1:(m+200)/2,(n-200)/2+1:(n+200)/2) = 1;
% support2 = zeros(m,n);
% support2((m-100)/2+1:(m+100)/2+1,(n-100)/2+1:(n+100)/2+1) = 1;
output =(((1-a)*input).*support+a*input);
end

