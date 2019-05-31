function d = Dist2(W,P)
%DIST Euclidean distance weight function.
%
% Dist2(W,P) takes an SxR weight matrix and RxQ input matrix and
% returns the SxQ matrix of distances between W's rows and P's columns.
%

w2 = sum(W.^2,2);
p2 = sum(P.^2,1);

d2 = bsxfun(@plus,w2,p2) - 2*W*P;
d = sqrt(d2);