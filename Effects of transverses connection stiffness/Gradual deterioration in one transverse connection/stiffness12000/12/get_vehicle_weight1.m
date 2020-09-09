function [ vechicle_weight ] = get_vehicle_weight1( small_vehicle_mass_mean, small_vehicle_mass_std, ...
    middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_location_parameter, ...
    large_vehicle_mass_scale_parameter, probability_generating_small_vehicle,probability_generating_middle_vehicle,m,n )
%GET_VEHICLE_WEIGHT1 以两个正态分布和一个极值分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean  --  正态分布的两个均值
%          small_vehicle_mass_std, middle_vehicle_mass_std --  正态分布的两个标准差
%          large_vehicle_mass_location_parameter  --  极值分布的位置参数
%          large_vehicle_mass_scale_parameter  --  极值分布的尺度参数
%          probability_generating_small_vehicle, probability_generating_middle_vehicle --  产生正态分布随机数的两个概率
%          m,n  --  产生m行n列的随机车重
%   输出：
%          vechicle_weight  --  随机车重

vechicle_weight=zeros(m,n);

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vechicle_weight(i,j)=normrnd(small_vehicle_mass_mean,small_vehicle_mass_std);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vechicle_weight(i,j)= normrnd(middle_vehicle_mass_mean,middle_vehicle_mass_std);
        else
            vechicle_weight(i,j)=evrnd(large_vehicle_mass_location_parameter,large_vehicle_mass_scale_parameter);
        end
    end
end
end