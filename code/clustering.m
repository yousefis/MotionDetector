
function [obj,zhat]=clustering(X,K)
%#codegen
coder.inline('never')
coder.extrinsic('gmdistribution.fit')
options = statset('Display','off');
obj = gmdistribution.fit(X,K,'Options',options,'Regularize', eps);
 c = cluster(obj,X);
 zhat=c;
end
