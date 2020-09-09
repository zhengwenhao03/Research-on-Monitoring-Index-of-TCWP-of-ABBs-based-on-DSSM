function [ load_spectrum ] = get_load_spectrum( simulation_hour, bridge_length, precast_beam_number, ...
    node_number, sample_second, sampling_frequency, average_interval_of_generating_vehicle, ...
    small_vehicle_mass_mean, small_vehicle_mass_std, middle_vehicle_mass_mean, ...
    middle_vehicle_mass_std, large_vehicle_mass_location_parameter, large_vehicle_mass_scale_parameter, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, vehicle_speed_mean, ...
    vehicle_speed_std)
%FORCE 产生等效力及其均值谱
%输入：
%    hour  --  模拟的时间，单位：h
%    LL  --  桥梁全长
%    MM  --  共有MM片预制梁
%    NN  --  每片预制梁有NN个节点
%    t  --  采样帧时长，单位：秒
%    fs  --  采样频率
%    DT  --  平均每隔DT秒有一辆车上桥
%    VW_mu1, VW_mu2  --  正态分布的两个均值，单位：吨
%    VW_sigma1, VW_sigma2 --  正态分布的两个标准差，单位：吨
%    VW_mu3  --  极值分布的位置参数，单位：吨
%    VW_sigma3  --  极值分布的尺度参数，单位：吨
%    P1, P2 --  产生正态分布随机数的两个概率
%    VV_mu,VV_sigma  --  正态分布随机车速的均值和标准差，单位：千米/小时
%    VP_mu,VP_sigma  --  正态分布随机车辆横向位置的均值和标准差，单位：米
%输出：
%    p  --  等效力荷载时程向量
%    PP  --  等效力的幅值谱，三维数组，第一维表示节点编号，第二维表示计算步数，第三维储存幅值谱

T=simulation_hour*60*60;  %模拟的时间总长，单位：秒
dt=1/sampling_frequency;  %采样时间间隔
L=bridge_length/(node_number-1);  %每个单元长，单位：米
load_time_history=zeros(precast_beam_number*(node_number-2),floor(T*sampling_frequency)+1200);  %荷载时程

for k = 1:precast_beam_number
    Vehicle_or_not = binornd(1, 1/average_interval_of_generating_vehicle/sampling_frequency/precast_beam_number, ...
        1, floor(T*sampling_frequency));  %judge if vehicles move onto a bridge
    vehicle_sampling_point = find(Vehicle_or_not==1);
    vehicle_number = length(vehicle_sampling_point);
    traffic = zeros(2, vehicle_number);
    traffic(1,:) = 1000*9.8*get_vehicle_weight1( small_vehicle_mass_mean, small_vehicle_mass_std, ...
        middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_location_parameter, ...
        large_vehicle_mass_scale_parameter, probability_generating_small_vehicle, ...
        probability_generating_middle_vehicle, 1, vehicle_number );  %vehicle weight, unit: N
    traffic(2,:) = normrnd(vehicle_speed_mean, vehicle_speed_std, 1, vehicle_number)/3.6;  %vehicle speed, unit: m/s
    for ii = 1:vehicle_number  %compute load time history
        for jj = 2:node_number-1
            tt1 = ceil((jj-2)*L/traffic(2,ii)/dt)*dt:dt:floor((jj-1)*L/traffic(2,ii)/dt)*dt;
            pp = traffic(1,ii)*(traffic(2,ii)*tt1-(jj-2)*L)/L;
            load_time_history((jj-2)*precast_beam_number+k, vehicle_sampling_point(ii)+ceil((jj-2)*L/traffic(2,ii)/dt):vehicle_sampling_point(ii)+floor((jj-1)*L/traffic(2,ii)/dt))= ...
                load_time_history((jj-2)*precast_beam_number+k,vehicle_sampling_point(ii)+ceil((jj-2)*L/traffic(2,ii)/dt):vehicle_sampling_point(ii)+floor((jj-1)*L/traffic(2,ii)/dt))+pp;
            tt2=ceil((jj-1)*L/traffic(2,ii)/dt)*dt:dt:floor(jj*L/traffic(2,ii)/dt)*dt;
            pp=traffic(1,ii)*(jj*L-traffic(2,ii)*tt2)/L;
            load_time_history((jj-2)*precast_beam_number+k,vehicle_sampling_point(ii)+ceil((jj-1)*L/traffic(2,ii)/dt):vehicle_sampling_point(ii)+floor(jj*L/traffic(2,ii)/dt))=...
                load_time_history((jj-2)*precast_beam_number+k,vehicle_sampling_point(ii)+ceil((jj-1)*L/traffic(2,ii)/dt):vehicle_sampling_point(ii)+floor(jj*L/traffic(2,ii)/dt))+pp;
        end
    end
end
load_time_history = load_time_history(:,1:floor(T*sampling_frequency));
clear Vehicle_or_not vehicle_sampling_point traffic

%compute load frequency spectrum
sample_length = sample_second * sampling_frequency;
NFFT = 2^nextpow2(sample_length);
load_spectrum = zeros(2*precast_beam_number*node_number, floor(T/sample_second), NFFT);

for ii = 1:precast_beam_number*(node_number-2)
    for m=1:floor(T/sample_second)
        load_spectrum(2*precast_beam_number+2*ii-1, m, :) = fft(load_time_history(ii,(m-1)*sample_length+1:m*sample_length), NFFT)/NFFT*2;
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