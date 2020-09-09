clear;close all;clc
%% Initialize
simulation_hour = 24;  %unit: hour
sample_second = 80;  %unit: second
sampling_frequency = 50;  %unit: Hz
sample_length = sample_second * sampling_frequency;
time_step_number = floor(simulation_hour*60*60/sample_second);

%Parameters of bridge
bridge_length = 30;  %unit: m
precast_beam_number = 5;
node_number = 9;
elasticity_modulus = 2.8e10;  %unit: Pa
cross_section_area_precast_beam = 0.9220;  %unit: m^2
moment_of_inertia_precast_beam = 0.4361;  %unit: m^4
density = 2500;  %unit: kg/m^3
spring_stiffness_matrix = 4000e3*ones(precast_beam_number-1,node_number-2);
mass_precast_beam = density*bridge_length*cross_section_area_precast_beam;  %unit: kg
mass_segment = mass_precast_beam/(node_number-1);    %unit: kg
[M] = get_mass_matrix(bridge_length, precast_beam_number, node_number, mass_segment);
[K] = get_stiffness_matrix(precast_beam_number, node_number, elasticity_modulus, ...
    moment_of_inertia_precast_beam, bridge_length, spring_stiffness_matrix);
[C] = get_damping_matrix(M, K);

NFFT = 2^nextpow2(sample_length);  %point number of FFT
omega = 2*pi*sampling_frequency/NFFT*(0:NFFT/2-1);  %discrete frequency

%Parameters of traffic flow
average_interval_of_generating_vehicle = 1;
small_vehicle_mass_mean = 1.5;  %unit: t
small_vehicle_mass_std = 0.5;  %unit: t
middle_vehicle_mass_mean = 30;  %unit: t
middle_vehicle_mass_std = 5;  %unit: t
large_vehicle_mass_location_parameter = 80;  %unit: t
large_vehicle_mass_scale_parameter = 10;  %unit: t
% probability_generating_small_vehicle = 0.6;
% probability_generating_middle_vehicle = 0.3;
vehicle_speed_mean = 35;  %unit: km/h
vehicle_speed_std = 3;  %unit: km/h

%% get traffic flow
traffic = cell(precast_beam_number,1);
[traffic] = get_vehicle_generation_point(traffic,simulation_hour,...
    average_interval_of_generating_vehicle,sampling_frequency);
[traffic] = get_vehicle_speed(traffic,vehicle_speed_mean,vehicle_speed_std);

x_axis = 0.1:0.1:0.7;
index = zeros(precast_beam_number-1,length(x_axis));
counter = 0;
for probability_generating_large_vehicle = x_axis
    probability_generating_small_vehicle = (1-probability_generating_large_vehicle)*2/3;
    probability_generating_middle_vehicle = (1-probability_generating_large_vehicle)*1/3;
    counter = counter + 1;
    [traffic] = get_vehicle_weight(traffic,...
        small_vehicle_mass_mean,small_vehicle_mass_std,middle_vehicle_mass_mean,...
        middle_vehicle_mass_std,large_vehicle_mass_location_parameter,...
        large_vehicle_mass_scale_parameter,probability_generating_small_vehicle,...
        probability_generating_middle_vehicle);
    
    % compute load spectrum
    [ load_spectrum ] = get_load_spectrum( traffic, simulation_hour, bridge_length, ...
        node_number, sample_second, sampling_frequency);
    
    % compute displacement spectrum
    displacement_spectrum = zeros(size(load_spectrum));
    for ii = 1:NFFT/2
        displacement_spectrum(:,:,ii) = (K+1i*omega(ii)*C-omega(ii)^2*M)\squeeze(load_spectrum(:,:,ii));
    end
    displacement_spectrum = abs(displacement_spectrum);
    
    % compute index
    correlation_coefficient = zeros(precast_beam_number-1, time_step_number);
    correlation_coefficient_mean = zeros(precast_beam_number-1, time_step_number);
    for ii = 1:precast_beam_number-1
        new_correlation_coefficient = corrcoef(squeeze(displacement_spectrum((node_number-2)*precast_beam_number+2*ii-1,1,:)), ...
            squeeze(displacement_spectrum((node_number-2)*precast_beam_number+2*ii+1,1,:)));
        new_correlation_coefficient(isnan(new_correlation_coefficient)) = 0;
        correlation_coefficient(ii, 1) = new_correlation_coefficient(1, 2);
        correlation_coefficient_mean(ii, 1) = mean(correlation_coefficient(ii, 1:1));
        for jj = 2:time_step_number
            new_correlation_coefficient = corrcoef(squeeze(displacement_spectrum((node_number-2)*precast_beam_number+2*ii-1,jj,:)), ...
                squeeze(displacement_spectrum((node_number-2)*precast_beam_number+2*ii+1,jj,:)));
            new_correlation_coefficient(isnan(new_correlation_coefficient)) = correlation_coefficient_mean(ii,jj-1);
            correlation_coefficient(ii,jj) = new_correlation_coefficient(1, 2);
            correlation_coefficient_mean(ii, jj) = mean(correlation_coefficient(ii, 1:jj));
        end
    end
    index(:,counter) = correlation_coefficient_mean(:,end);
end
%% plot results
figure
plot(x_axis,index(1,:),'Marker','<','MarkerSize',7,'LineWidth',1.5);hold on
plot(x_axis,index(2,:),'Marker','s','MarkerSize',7,'linewidth',1.5);hold on
plot(x_axis,index(3,:),'Marker','x','MarkerSize',7,'linewidth',1.5);hold on
plot(x_axis,index(4,:),'Marker','>','MarkerSize',7,'linewidth',1.5);
xlim([x_axis(1),x_axis(end)])
legend('DSSM_{12}','DSSM_{23}','DSSM_{34}','DSSM_{45}','Location','southeast')
xlabel('propotion of large vehicles')
ylabel('Index')
set(gca,'fontsize',13)