function [traffic] = get_vehicle_weight(traffic,...
    small_vehicle_mass_mean,small_vehicle_mass_std,middle_vehicle_mass_mean,...
    middle_vehicle_mass_std,large_vehicle_mass_location_parameter,...
    large_vehicle_mass_scale_parameter,probability_generating_small_vehicle,...
    probability_generating_middle_vehicle,distribution_type)
%ADD_TRAFFIC_FLOW_WEIGHTS
%   此处显示详细说明
small_vehicle_mass_scale_parameter = small_vehicle_mass_std / sqrt(1.645);
small_vehicle_mass_location_parameter = small_vehicle_mass_mean - 0.57722*small_vehicle_mass_scale_parameter;
middle_vehicle_mass_scale_parameter = middle_vehicle_mass_std / sqrt(1.645);
middle_vehicle_mass_location_parameter = middle_vehicle_mass_mean - 0.57722*middle_vehicle_mass_scale_parameter;
large_vehicle_mass_mean = large_vehicle_mass_location_parameter + 0.57722*large_vehicle_mass_scale_parameter;  %unit: t
large_vehicle_mass_std = sqrt(1.645) * large_vehicle_mass_scale_parameter;  %unit: t
precast_beam_number = length(traffic);
if nargin == 9
    distribution_type = 'default';
end

if strcmp(distribution_type,'default')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_default( small_vehicle_mass_mean, small_vehicle_mass_std, ...
            middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_location_parameter, ...
            large_vehicle_mass_scale_parameter, probability_generating_small_vehicle, ...
            probability_generating_middle_vehicle, 1, vehicle_number );
    end
    
elseif strcmp(distribution_type,'normal')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_normal( small_vehicle_mass_mean, small_vehicle_mass_std, ...
            middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, ...
            large_vehicle_mass_std, probability_generating_small_vehicle, ...
            probability_generating_middle_vehicle, 1, vehicle_number );
    end
    
elseif strcmp(distribution_type,'lognormal') || strcmp(distribution_type,'logarithmic normal')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_lognormal( small_vehicle_mass_mean, small_vehicle_mass_std, ...
            middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, ...
            large_vehicle_mass_std, probability_generating_small_vehicle, ...
            probability_generating_middle_vehicle, 1, vehicle_number );
    end
elseif strcmp(distribution_type,'exponential') || strcmp(distribution_type,'exponent')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_exponential( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
            large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, ...
            1, vehicle_number );
    end
    
elseif strcmp(distribution_type,'gamma')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_gamma( small_vehicle_mass_mean, small_vehicle_mass_std, ...
            middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, large_vehicle_mass_std, ...
            probability_generating_small_vehicle, probability_generating_middle_vehicle, 1, vehicle_number );
    end
    
elseif strcmp(distribution_type,'Weibull')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_Weibull( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
            large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, ...
            1, vehicle_number );
    end
    
elseif strcmp(distribution_type,'extreme value')
    for k = 1:precast_beam_number
        vehicle_number = size(traffic{k},2);
        traffic{k}(2,:) = 1000*9.8*get_vehicle_weight_extreme_value( small_vehicle_mass_location_parameter, ...
            small_vehicle_mass_scale_parameter, middle_vehicle_mass_location_parameter, ...
            middle_vehicle_mass_scale_parameter, large_vehicle_mass_location_parameter, ...
            large_vehicle_mass_scale_parameter, probability_generating_small_vehicle, ...
            probability_generating_middle_vehicle, 1, vehicle_number );
    end
    
else
    error('please input right vehicle weight distribution type')
end
end

