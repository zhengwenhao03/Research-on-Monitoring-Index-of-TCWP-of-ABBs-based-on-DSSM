function [ vehicle_weight ] = get_vehicle_weight_extreme_value( small_vehicle_mass_location_parameter, ...
    small_vehicle_mass_scale_parameter, middle_vehicle_mass_location_parameter, middle_vehicle_mass_scale_parameter, ...
    large_vehicle_mass_location_parameter, large_vehicle_mass_scale_parameter, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight7 以三个极值分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean  --  正态分布的三个均值
%          small_vehicle_mass_std, middle_vehicle_mass_std,large_vehicle_mass_std  --  正态分布的三个标准差
%          probability_generating_small_vehicle, probability_generating_middle_vehicle --  产生正态分布随机数的两个概率
%          m,n  --  产生m行n列的随机车重
%   输出：
%          vehicle_weight  --  随机车重

vehicle_weight=zeros(m,n);

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vehicle_weight(i,j)=evrnd(small_vehicle_mass_location_parameter,small_vehicle_mass_scale_parameter);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vehicle_weight(i,j)=evrnd(middle_vehicle_mass_location_parameter,middle_vehicle_mass_scale_parameter);
        else
            vehicle_weight(i,j)=evrnd(large_vehicle_mass_location_parameter,large_vehicle_mass_scale_parameter);
        end
    end
end
end