function [ load_spectrum ] = get_load_spectrum( simulation_hour, bridge_length, precast_beam_number, ...
    node_number, sample_second, sampling_frequency, average_interval_of_generating_vehicle, ...
    small_vehicle_mass_mean, small_vehicle_mass_std, middle_vehicle_mass_mean, ...
    middle_vehicle_mass_std, large_vehicle_mass_location_parameter, large_vehicle_mass_scale_parameter, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, vehicle_speed_mean, ...
    vehicle_speed_std)
%FORCE ������Ч�������ֵ��
%���룺
%    hour  --  ģ���ʱ�䣬��λ��h
%    LL  --  ����ȫ��
%    MM  --  ����MMƬԤ����
%    NN  --  ÿƬԤ������NN���ڵ�
%    t  --  ����֡ʱ������λ����
%    fs  --  ����Ƶ��
%    DT  --  ƽ��ÿ��DT����һ��������
%    VW_mu1, VW_mu2  --  ��̬�ֲ���������ֵ����λ����
%    VW_sigma1, VW_sigma2 --  ��̬�ֲ���������׼���λ����
%    VW_mu3  --  ��ֵ�ֲ���λ�ò�������λ����
%    VW_sigma3  --  ��ֵ�ֲ��ĳ߶Ȳ�������λ����
%    P1, P2 --  ������̬�ֲ����������������
%    VV_mu,VV_sigma  --  ��̬�ֲ�������ٵľ�ֵ�ͱ�׼���λ��ǧ��/Сʱ
%    VP_mu,VP_sigma  --  ��̬�ֲ������������λ�õľ�ֵ�ͱ�׼���λ����
%�����
%    p  --  ��Ч������ʱ������
%    PP  --  ��Ч���ķ�ֵ�ף���ά���飬��һά��ʾ�ڵ��ţ��ڶ�ά��ʾ���㲽��������ά�����ֵ��

T=simulation_hour*60*60;  %ģ���ʱ���ܳ�����λ����
dt=1/sampling_frequency;  %����ʱ����
L=bridge_length/(node_number-1);  %ÿ����Ԫ������λ����
load_time_history=zeros(precast_beam_number*(node_number-2),floor(T*sampling_frequency)+1200);  %����ʱ��

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