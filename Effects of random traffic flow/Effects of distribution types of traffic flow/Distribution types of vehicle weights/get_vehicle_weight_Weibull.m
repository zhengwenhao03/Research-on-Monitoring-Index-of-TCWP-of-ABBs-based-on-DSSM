function [ vehicle_weight ] = get_vehicle_weight_Weibull( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
    large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight6 以三个瑞利分布模拟随机车重
%   输入：
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean
%                      --  小、中、大型车车重瑞利分布的三个均值
%          probability_generating_small_vehicle  --  小型车的概率
%          probability_generating_middle_vehicle --  中型车的概率
%          m, n  --  产生m行n列的随机车重
%   输出：
%          vehicle_weight  --  随机车重

vehicle_weight=zeros(m,n);
sigma1=sqrt(2/pi)*small_vehicle_mass_mean;
sigma2=sqrt(2/pi)*middle_vehicle_mass_mean;
sigma3=sqrt(2/pi)*large_vehicle_mass_mean;

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vehicle_weight(i,j)=raylrnd(sigma1);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vehicle_weight(i,j)=raylrnd(sigma2);
        else
            vehicle_weight(i,j)=raylrnd(sigma3);
        end
    end
end
end