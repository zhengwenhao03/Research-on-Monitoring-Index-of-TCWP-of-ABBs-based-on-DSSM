function [ vechicle_weight ] = get_vehicle_weight_normal( small_vehicle_mass_mean, small_vehicle_mass_std, ...
    middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, large_vehicle_mass_std, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight2 以三个正态分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean  --  正态分布的三个均值
%          small_vehicle_mass_std, middle_vehicle_mass_std,large_vehicle_mass_std  --  正态分布的三个标准差
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
            vechicle_weight(i,j)=normrnd(large_vehicle_mass_mean,large_vehicle_mass_std);
        end
    end
end
end