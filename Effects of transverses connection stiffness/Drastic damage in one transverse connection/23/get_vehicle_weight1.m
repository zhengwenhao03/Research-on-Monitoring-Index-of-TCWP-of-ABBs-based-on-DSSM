function [ vechicle_weight ] = get_vehicle_weight1( small_vehicle_mass_mean, small_vehicle_mass_std, ...
    middle_vehicle_mass_mean, middle_vehicle_mass_std, large_vehicle_mass_location_parameter, ...
    large_vehicle_mass_scale_parameter, probability_generating_small_vehicle,probability_generating_middle_vehicle,m,n )
%GET_VEHICLE_WEIGHT1 ��������̬�ֲ���һ����ֵ�ֲ�ģ���������
%   ���룺
%          small_vehicle_mass_mean, middle_vehicle_mass_mean  --  ��̬�ֲ���������ֵ
%          small_vehicle_mass_std, middle_vehicle_mass_std --  ��̬�ֲ���������׼��
%          large_vehicle_mass_location_parameter  --  ��ֵ�ֲ���λ�ò���
%          large_vehicle_mass_scale_parameter  --  ��ֵ�ֲ��ĳ߶Ȳ���
%          probability_generating_small_vehicle, probability_generating_middle_vehicle --  ������̬�ֲ����������������
%          m,n  --  ����m��n�е��������
%   �����
%          vechicle_weight  --  �������

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