clear;close all;clc
%% Initialize
simulation_hour = 36;  %unit: hour
sample_second = 80;  %unit: second
sampling_frequency = 50;  %unit: Hz
sample_length = sample_second * sampling_frequency;
time_step_number = floor(simulation_hour*60*60/sample_second);
change_stiffness_hour = 12;  %突然改变横向联系刚度的时间
statistic_time = 12;  %统计相关系数的时间
k = 0.5; %改变刚度为原来的K倍

%Parameters of bridge
bridge_length = 30;  %unit: m
precast_beam_number = 5;
node_number = 9;
elasticity_modulus = 2.8e10;  %unit: Pa
cross_section_area_precast_beam = 0.9220;  %unit: m^2
moment_of_inertia_precast_beam = 0.4361;  %unit: m^4
density = 2500;  %unit: kg/m^3
spring_stiffness_matrix = 24000e3*ones(precast_beam_number-1,node_number-2);
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
probability_generating_small_vehicle = 0.6;
probability_generating_middle_vehicle = 0.3;
vehicle_speed_mean = 35;  %unit: km/h
vehicle_speed_std = 3;  %unit: km/h

%% 根据位移幅值谱计算相关系数，再计算相关系数的均值
[load_spectrum] = get_load_spectrum( simulation_hour, bridge_length, precast_beam_number, ...
    node_number, sample_second, sampling_frequency, average_interval_of_generating_vehicle, ...
    small_vehicle_mass_mean, small_vehicle_mass_std, middle_vehicle_mass_mean, ...
    middle_vehicle_mass_std, large_vehicle_mass_location_parameter, large_vehicle_mass_scale_parameter, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, vehicle_speed_mean, ...
    vehicle_speed_std);

%%
displacement_spectrum = zeros(size(load_spectrum));
%compute displacement spectrum before change spring stiffness
for ii = 1:NFFT/2
    displacement_spectrum(:,1:change_stiffness_hour*3600/sample_second,ii) = ...
        (K + 1i*omega(ii)*C - omega(ii)^2*M) \ squeeze(load_spectrum(:,1:change_stiffness_hour*3600/sample_second,ii));
end
%change spring stiffness
spring_stiffness_matrix(1, :) = k * spring_stiffness_matrix(1, :);
[K] = get_stiffness_matrix(precast_beam_number, node_number, elasticity_modulus, ...
    moment_of_inertia_precast_beam, bridge_length, spring_stiffness_matrix);
[C] = get_damping_matrix(M, K);
for ii=1:NFFT/2  %计算横向联系刚度改变之后的位移谱
    displacement_spectrum(:,change_stiffness_hour*3600/sample_second+1:end,ii) = ...
        (K + 1i*omega(ii)*C - omega(ii)^2*M) \ squeeze(load_spectrum(:,change_stiffness_hour*3600/sample_second+1:end,ii));
end
displacement_spectrum = abs(displacement_spectrum);

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
        if jj <= statistic_time*3600/sample_second  %如果计算时间小于等于24小时，则统计之前所有时间步的相关系数均值作为指标
            correlation_coefficient_mean(ii,jj) = mean(correlation_coefficient(ii,1:jj));
        else  %否则， 统计往前24小时至当前时间步的相关系数均值作为指标
            correlation_coefficient_mean(ii,jj) = mean(correlation_coefficient(ii,jj-statistic_time*3600/sample_second+1:jj));
        end
    end
end

%% plot results
x_axis = (1:floor(simulation_hour*60*60/sample_second))*sample_second/60/60;
figure
plot(x_axis,correlation_coefficient_mean(1,:),'Marker','<','MarkerIndices',time_step_number/10:time_step_number/10:time_step_number,'MarkerSize',7,'LineWidth',1.5);hold on
plot(x_axis,correlation_coefficient_mean(2,:),'marker','s','MarkerIndices',time_step_number/10:time_step_number/10:time_step_number,'MarkerSize',7,'linewidth',1.5);hold on
plot(x_axis,correlation_coefficient_mean(3,:),'marker','x','MarkerIndices',time_step_number/10:time_step_number/10:time_step_number,'MarkerSize',7,'linewidth',1.5);hold on
plot(x_axis,correlation_coefficient_mean(4,:),'marker','>','MarkerIndices',time_step_number/10:time_step_number/10:time_step_number,'MarkerSize',7,'linewidth',1.5);
legend('DSSM_{12}','DSSM_{23}','DSSM_{34}','DSSM_{45}','Location','southeast')
xlabel('Time(h)')
ylabel('Index')
xlim([0,simulation_hour])
xticks((0:6:simulation_hour))
ylim([0.96,1])
grid on
set(gca,'FontSize',13)