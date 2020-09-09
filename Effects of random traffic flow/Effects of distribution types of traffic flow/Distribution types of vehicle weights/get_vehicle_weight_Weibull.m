function [ vehicle_weight ] = get_vehicle_weight_Weibull( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
    large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight6 �����������ֲ�ģ���������
%   ���룺
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean
%                      --  С���С����ͳ����������ֲ���������ֵ
%          probability_generating_small_vehicle  --  С�ͳ��ĸ���
%          probability_generating_middle_vehicle --  ���ͳ��ĸ���
%          m, n  --  ����m��n�е��������
%   �����
%          vehicle_weight  --  �������

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