function dist = calculate_distance(TimeSeries1,TimeSeries2,window_size)
    
    dist = 0;
    r = window_size;
    %%%%%%%%%%%%%%
    n = length(TimeSeries1);
    m = length(TimeSeries2);

    if (~exist('r','var')), r=0.1;              end
    if (r<1),               r=ceil(min(n,m)*r); end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %d = DTW_mex(TimeSeries1,TimeSeries2,r);
    
    d = dtw_m(TimeSeries1',TimeSeries2',r);
    %d = sqrt(sum((TimeSeries1-TimeSeries2).^2));
        
    %dist = dist + d^2;
    dist = d;