function [ vechicle_weight ] = get_vehicle_weight_lognormal( small_vehicle_mass_mean, small_vehicle_mass_std, ...
    middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, large_vehicle_mass_std, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight3 以三个对数正态分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean  --  对数正态分布的三个均值
%          small_vehicle_mass_std, middle_vehicle_mass_std,large_vehicle_mass_std  --  对数正态分布的三个标准差
%          probability_generating_small_vehicle  --  小型车的概率
%          probability_generating_middle_vehicle --  中型车的概率
%          m,n  --  产生m行n列的随机车重
%   输出：
%          vechicle_weight  --  随机车重

vechicle_weight=zeros(m,n);
mu1 = log((small_vehicle_mass_mean^2)/sqrt(small_vehicle_mass_std+small_vehicle_mass_mean^2));
sigma1 = sqrt(log(small_vehicle_mass_std/(small_vehicle_mass_mean^2)+1));
mu2 = log((middle_vehicle_mass_mean^2)/sqrt(middle_vehicle_mass_std+middle_vehicle_mass_mean^2));
sigma2 = sqrt(log(middle_vehicle_mass_std/(middle_vehicle_mass_mean^2)+1));
mu3 = log((large_vehicle_mass_mean^2)/sqrt(large_vehicle_mass_std+large_vehicle_mass_mean^2));
sigma3 = sqrt(log(large_vehicle_mass_std/(large_vehicle_mass_mean^2)+1));

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vechicle_weight(i,j)=normrnd(mu1,sigma1);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vechicle_weight(i,j)= normrnd(mu2,sigma2);
        else
            vechicle_weight(i,j)=normrnd(mu3,sigma3);
        end
    end
end
end