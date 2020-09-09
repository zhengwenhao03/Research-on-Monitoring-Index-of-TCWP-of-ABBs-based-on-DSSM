function [M] = get_mass_matrix(bridge_length, precast_beam_number, node_number, mass_segment)
%GET_MASS_MATRIX
%input:
%     bridge_length
%     precast_beam_number
%     node_number
%     mass_segment
%output:
%     M  --  mass matrix

moment_of_inertia = mass_segment*(bridge_length/(node_number-1))^2/12;

M = zeros(2*precast_beam_number*node_number);  %mass matrix
for ii=1:2:2*precast_beam_number
    M(ii,ii)=mass_segment/2;
    M(ii+1,ii+1)=moment_of_inertia/2;
end
for ii=2*precast_beam_number+1:2:2*precast_beam_number*(node_number-1)
    M(ii,ii)=mass_segment;
    M(ii+1,ii+1)=moment_of_inertia;
end
for ii=2*precast_beam_number*(node_number-1)+1:2:2*precast_beam_number*node_number
    M(ii,ii)=mass_segment/2;
    M(ii+1,ii+1)=moment_of_inertia/2;
end
%cross out constrainted degrees of freedom
for ii=2*precast_beam_number*node_number-1:-2:2*precast_beam_number*(node_number-1)+1
    M(:,ii)=[];
    M(ii,:)=[];
end
for ii=2*precast_beam_number-1:-2:1
    M(:,ii)=[];
    M(ii,:)=[];
end
end

