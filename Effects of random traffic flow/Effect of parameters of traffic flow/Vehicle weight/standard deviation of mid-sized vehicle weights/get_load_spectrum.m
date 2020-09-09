function [ load_spectrum ] = get_load_spectrum( traffic, simulation_hour, bridge_length, ...
    node_number, sample_second, sampling_frequency)
%FORCE ������Ч�������ֵ��
%���룺
%    hour  --  ģ���ʱ�䣬��λ��h
%    LL  --  ����ȫ��
%    MM  --  ����MMƬԤ����
%    NN  --  ÿƬԤ������NN���ڵ�
%    t  --  ����֡ʱ������λ����
%    fs  --  ����Ƶ��
%    DT  --  ƽ��ÿ��DT����һ��������
%�����
%    p  --  ��Ч������ʱ������
%    PP  --  ��Ч���ķ�ֵ�ף���ά���飬��һά��ʾ�ڵ��ţ��ڶ�ά��ʾ���㲽��������ά�����ֵ��
precast_beam_number = length(traffic);
simulation_second = simulation_hour*60*60;  %ģ���ʱ���ܳ�����λ����
sampling_interval = 1/sampling_frequency;  %����ʱ����
segment_length = bridge_length/(node_number-1);  %ÿ����Ԫ������λ����
load_time_history = zeros(precast_beam_number*(node_number-2),...
    floor(simulation_second*sampling_frequency)+1200);  %����ʱ��

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