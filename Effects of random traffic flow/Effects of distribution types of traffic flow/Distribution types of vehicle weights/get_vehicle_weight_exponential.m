function [ vehicle_weight ] = get_vehicle_weight_exponential( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
    large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight4 以三个指数分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean
%                      --  小、中、大型车车重指数分布的三个参数
%          probability_generating_small_vehicle  --  小型车的概率
%          probability_generating_middle_vehicle --  中型车的概率
%          m, n  --  产生m行n列的随机车重
%   输出：
%          Vechicle_Weight  --  随机车重

vehicle_weight=zeros(m,n);

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vehicle_weight(i,j)=exprnd(small_vehicle_mass_mean);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vehicle_weight(i,j)= exprnd(middle_vehicle_mass_mean);
        else
            vehicle_weight(i,j)=exprnd(large_vehicle_mass_mean);
        end
    end
end
end