function [ state ] = mpcaseToState( mpcase,params )

    w = zeros(params.ng, 1); w(params.windBuses) = 20;
    e = ones(params.nl, 1);
    g = rand(params.ng, 1); g = g/sum(g);
    d = rand(params.nb, 1)*100;
    state = struct('g', ones(params.ng, 1)/params.ng, 'b', 100, 'w', w, 't', 0, 'e', e, 'd', d);
    gnext = rand(params.ng, 1); gnext = gnext/sum(gnext);
    dg = gnext - g;
    action = struct('dg',dg); 

end

