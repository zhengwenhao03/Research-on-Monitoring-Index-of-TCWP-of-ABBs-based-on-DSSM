function [traffic] = get_vehicle_speed(traffic,vehicle_speed_mean,vehicle_speed_std,distribution_type)
%get_vehicle_speed
%   此处显示详细说明

alpha = vehicle_speed_mean^2/vehicle_speed_std^2;
beta = vehicle_speed_std^2/vehicle_speed_mean;
sigma = sqrt(2/pi)*vehicle_speed_mean;
precast_beam_number = length(traffic);

if nargin == 3
    distribution_type = 'normal';
end

if strcmp(distribution_type,'default') || strcmp(distribution_type,'normal')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(3,:) = normrnd(vehicle_speed_mean, vehicle_speed_std, 1, vehicle_number)/3.6;
    end
    
elseif strcmp(distribution_type,'gamma')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(3,:) = gamrnd(alpha, beta, 1, vehicle_number)/3.6;
    end
    
elseif strcmp(distribution_type,'Weibull')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(3,:) = raylrnd(sigma, 1, vehicle_number)/3.6;
    end
    
else
    error('please input right vehicle speed distribution type')
end
end