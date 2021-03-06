function [X,cspond,G] = make_cspond_set_Rt(N,w,h)
theta = 2*pi*rand(1,N);
t = 0.9*rand(2,N)-0.45;
r = ones(1,N);
%r = double(rand(1,N) > 0.5);
%r(r==0) = -1;
A = Rt.params_to_mtx([theta;t;r]);
x = PT.mtimesx(A,repmat(LAF.make_random(1),1,N));
M = [[w 0; 0 h] [0 0]';0 0 1];
M2 = [1 0 0; 0 1 0; 0 0 0; 0 0 1];
X = reshape(M2*M*reshape(x,3,[]),12,[]);
cspond = transpose(nchoosek(1:N,2));
G = repmat(1,1,size(X,2));
