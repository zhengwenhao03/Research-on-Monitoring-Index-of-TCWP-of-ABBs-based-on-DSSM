function [ vehicle_weight ] = get_vehicle_weight_gamma( small_vehicle_mass_mean, small_vehicle_mass_std, ...
    middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_mean, large_vehicle_mass_std, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight5 ������٤��ֲ�ģ���������
%   ���룺
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean  --  ٤��ֲ���������ֵ
%          small_vehicle_mass_std, middle_vehicle_mass_std,large_vehicle_mass_std  --  ٤��ֲ���������׼��
%          probability_generating_small_vehicle, probability_generating_middle_vehicle --  ����٤��ֲ����������������
%          m,n  --  ����m��n�е��������
%   �����
%          Vechicle_Weight  --  �������

vehicle_weight=zeros(m,n);
alpha1=small_vehicle_mass_mean^2/small_vehicle_mass_std^2;
beta1=small_vehicle_mass_std^2/small_vehicle_mass_mean;
alpha2=middle_vehicle_mass_mean^2/middle_vehicle_mass_std^2;
beta2=middle_vehicle_mass_std^2/middle_vehicle_mass_mean;
alpha3=large_vehicle_mass_mean^2/large_vehicle_mass_std^2;
beta3=large_vehicle_mass_std^2/large_vehicle_mass_mean;

for i=1:m
    for j=1:n
        a=rand(1);
        if a<probability_generating_small_vehicle
            vehicle_weight(i,j)=gamrnd(alpha1,beta1);
        elseif a<probability_generating_small_vehicle+probability_generating_middle_vehicle
            vehicle_weight(i,j)= gamrnd(alpha2,beta2);
        else
            vehicle_weight(i,j)=gamrnd(alpha3,beta3);
        end
    end
end
end