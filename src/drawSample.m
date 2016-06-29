function [r, Pr] = drawSample(mu, params, muStdRatio)
    buses = params.windBuses;
    mu_stoc = mu(buses,:);
    if(~(exist('muStdRatio','var') && ~isempty(muStdRatio)) )
        muStdRatio = 0.15;
    end
    r = mu;
    r(buses,:) = mu_stoc + mu_stoc*muStdRatio .* randn(size(mu_stoc));
    r(r<0) = 0;
    
    Pr = ones(size(mu));
    Pr(buses,:) = pdf('norm',r(buses,:),mu_stoc, mu_stoc.*muStdRatio);
    
%     Pr = ones(size(mu));
%     std = mu_stoc.*muStdRatio;
%     Pr(buses,:) = exp( -( r(buses,:)-mu_stoc ).^2 ./ (2*std.^2) ) ./ (sqrt(2*pi)*std);
%     a  = 1