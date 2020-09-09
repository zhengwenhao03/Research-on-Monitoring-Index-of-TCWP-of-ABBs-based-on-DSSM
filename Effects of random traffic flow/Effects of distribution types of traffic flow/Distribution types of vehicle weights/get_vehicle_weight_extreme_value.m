function [ vehicle_weight ] = get_vehicle_weight_extreme_value( small_vehicle_mass_location_parameter, ...
    small_vehicle_mass_scale_parameter, middle_vehicle_mass_location_parameter, middle_vehicle_mass_scale_parameter, ...
    large_vehicle_mass_location_parameter, large_vehicle_mass_scale_parameter, ...
    probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight7 ��������ֵ�ֲ�ģ���������
%   ���룺
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean  --  ��̬�ֲ���������ֵ
%          small_vehicle_mass_std, middle_vehicle_mass_std,large_vehicle_mass_std  --  ��̬�ֲ���������׼��
%          probability_generating_small_vehicle, probability_generating_middle_vehicle --  ������̬�ֲ����������������
%          m,n  --  ����m��n�е��������
%   �����
%          vehicle_weight  --  �������

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