function [ vehicle_weight ] = get_vehicle_weight_exponential( small_vehicle_mass_mean, middle_vehicle_mass_mean, ...
    large_vehicle_mass_mean, probability_generating_small_vehicle, probability_generating_middle_vehicle, m, n )
%get_vehicle_weight4 ������ָ���ֲ�ģ���������
%   ���룺
%          small_vehicle_mass_mean, middle_vehicle_mass_mean,large_vehicle_mass_mean
%                      --  С���С����ͳ�����ָ���ֲ�����������
%          probability_generating_small_vehicle  --  С�ͳ��ĸ���
%          probability_generating_middle_vehicle --  ���ͳ��ĸ���
%          m, n  --  ����m��n�е��������
%   �����
%          Vechicle_Weight  --  �������

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