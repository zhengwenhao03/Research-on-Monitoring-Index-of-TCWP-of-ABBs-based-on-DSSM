function [traffic] = get_vehicle_generation_point(traffic,simulation_hour,...
    average_interval_of_generating_vehicle,sampling_frequency)
%GET_GENERATE_VEHICLE_POINT 此处显示有关此函数的摘要
%   此处显示详细说明

simulation_second = simulation_hour*60*60;
precast_beam_number = length(traffic);

for k = 1:precast_beam_number
    Vehicle_or_not = binornd(1, 1/average_interval_of_generating_vehicle/sampling_frequency/precast_beam_number, ...
        1, floor(simulation_second*sampling_frequency));  %judge if vehicles move onto a bridge
    traffic{k}(1,:) = find(Vehicle_or_not==1);
end
end


