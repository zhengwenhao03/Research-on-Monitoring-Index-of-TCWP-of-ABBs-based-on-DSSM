function [ load_spectrum ] = get_load_spectrum( traffic, simulation_hour, bridge_length, ...
    node_number, sample_second, sampling_frequency)
%FORCE 产生等效力及其均值谱
%输入：
%    hour  --  模拟的时间，单位：h
%    LL  --  桥梁全长
%    MM  --  共有MM片预制梁
%    NN  --  每片预制梁有NN个节点
%    t  --  采样帧时长，单位：秒
%    fs  --  采样频率
%    DT  --  平均每隔DT秒有一辆车上桥
%输出：
%    p  --  等效力荷载时程向量
%    PP  --  等效力的幅值谱，三维数组，第一维表示节点编号，第二维表示计算步数，第三维储存幅值谱
precast_beam_number = length(traffic);
simulation_second = simulation_hour*60*60;  %模拟的时间总长，单位：秒
sampling_interval = 1/sampling_frequency;  %采样时间间隔
segment_length = bridge_length/(node_number-1);  %每个单元长，单位：米
load_time_history = zeros(precast_beam_number*(node_number-2),...
    floor(simulation_second*sampling_frequency)+1200);  %荷载时程

for k = 1:precast_beam_number
    vehicle_number = size(traffic{k},2);
    %compute load time history
    for ii = 1:vehicle_number
        for jj = 2:node_number-1
            tt1 = ceil((jj-2)*segment_length/traffic{k}(3,ii)/sampling_interval)*sampling_interval : ...
                sampling_interval : floor((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval)*sampling_interval;
            pp = traffic{k}(2,ii)*(traffic{k}(3,ii)*tt1-(jj-2)*segment_length)/segment_length;
            load_time_history((jj-2)*precast_beam_number+k, ...
                traffic{k}(1,ii)+ceil((jj-2)*segment_length/traffic{k}(3,ii)/sampling_interval) : ...
                traffic{k}(1,ii)+floor((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval)) = ...
                load_time_history((jj-2)*precast_beam_number+k, ...
                traffic{k}(1,ii)+ceil((jj-2)*segment_length/traffic{k}(3,ii)/sampling_interval) : ...
                traffic{k}(1,ii)+floor((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval))+pp;
            tt2 = ceil((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval)*sampling_interval : ...
                sampling_interval:floor(jj*segment_length/traffic{k}(3,ii)/sampling_interval)*sampling_interval;
            pp = traffic{k}(2,ii)*(jj*segment_length-traffic{k}(3,ii)*tt2)/segment_length;
            load_time_history((jj-2)*precast_beam_number+k, ...
                traffic{k}(1,ii)+ceil((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval) : ...
                traffic{k}(1,ii)+floor(jj*segment_length/traffic{k}(3,ii)/sampling_interval)) = ...
                load_time_history((jj-2)*precast_beam_number+k, ...
                traffic{k}(1,ii)+ceil((jj-1)*segment_length/traffic{k}(3,ii)/sampling_interval) : ...
                traffic{k}(1,ii)+floor(jj*segment_length/traffic{k}(3,ii)/sampling_interval))+pp;
        end
    end
end
load_time_history = load_time_history(:,1:floor(simulation_second*sampling_frequency));

%compute load frequency spectrum
sample_length = sample_second * sampling_frequency;
NFFT = 2^nextpow2(sample_length);
load_spectrum = zeros(2*precast_beam_number*node_number, floor(simulation_second/sample_second), NFFT);

for ii = 1:precast_beam_number*(node_number-2)
    for m=1:floor(simulation_second/sample_second)
        load_spectrum(2*precast_beam_number+2*ii-1, m, :) = ...
            fft(load_time_history(ii,(m-1)*sample_length+1:m*sample_length), NFFT)/NFFT*2;
    end
end
load_spectrum = load_spectrum(:,:,1:NFFT/2);

%cross out constrainted degrees of freedom
for ii=2*precast_beam_number*node_number-1:-2:2*precast_beam_number*(node_number-1)+1
    load_spectrum(ii,:,:)=[];
end
for ii=2*precast_beam_number-1:-2:1
    load_spectrum(ii,:,:)=[];
end

end