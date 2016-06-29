function ph = getTimeFeatures(state,params)
run('get_global_constants.m');
ph = [1;state.t];