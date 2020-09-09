function [K] = get_stiffness_matrix(precast_beam_number, node_number, elasticity_modulus, ...
    moment_of_inertia_precast_beam, bridge_length, spring_stiffness_matrix)
%GET_STIFFNESS_MATRIX
%input£º
%     precast_beam_number
%     node_number
%     elasticity_modulus
%     moment_of_inertia_precast_beam
%     bridge_length
%     spring_stiffness_matrix
%output£º
%     K  --  stiffness matrix

segment_length = bridge_length/(node_number-1);
K = zeros(2*precast_beam_number*node_number);

for ii = 1:precast_beam_number  %the nodes in the first column
    K(2*ii-1,2*ii-1)=12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*ii,2*ii-1)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*ii-1+2*precast_beam_number,2*ii-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*ii+2*precast_beam_number,2*ii-1)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    
    K(2*ii-1,2*ii)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*ii,2*ii)=4*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*ii-1+2*precast_beam_number,2*ii)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*ii+2*precast_beam_number,2*ii)=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
end

for jj = 2:node_number-1  %the nodes in the middle columns
    %the first nodes in the middle columns
    K(2*precast_beam_number*(jj-2)+1,2*precast_beam_number*(jj-1)+1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*precast_beam_number*(jj-2)+2,2*precast_beam_number*(jj-1)+1)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*(jj-1)+1,2*precast_beam_number*(jj-1)+1)=24*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3+spring_stiffness_matrix(1,jj-1);
    K(2*precast_beam_number*(jj-1)+2,2*precast_beam_number*(jj-1)+1)=0;
    K(2*precast_beam_number*(jj-1)+3,2*precast_beam_number*(jj-1)+1)=-spring_stiffness_matrix(1,jj-1);
    K(2*precast_beam_number*(jj-1)+4,2*precast_beam_number*(jj-1)+1)=0;
    K(2*precast_beam_number*jj+1,2*precast_beam_number*(jj-1)+1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*precast_beam_number*jj+2,2*precast_beam_number*(jj-1)+1)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    
    K(2*precast_beam_number*(jj-2)+1,2*precast_beam_number*(jj-1)+2)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*(jj-2)+2,2*precast_beam_number*(jj-1)+2)=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*precast_beam_number*(jj-1)+1,2*precast_beam_number*(jj-1)+2)=0;
    K(2*precast_beam_number*(jj-1)+2,2*precast_beam_number*(jj-1)+2)=8*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*precast_beam_number*jj+1,2*precast_beam_number*(jj-1)+2)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*jj+2,2*precast_beam_number*(jj-1)+2)=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    
    %the middle nodes in the middle columns
    for ii=2:precast_beam_number-1
        K(2*(precast_beam_number*(jj-1)+ii)-1-2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii)-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
        K(2*(precast_beam_number*(jj-1)+ii)-2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii)-1)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
        K(2*(precast_beam_number*(jj-1)+ii)-3,2*(precast_beam_number*(jj-1)+ii)-1)=-spring_stiffness_matrix(ii-1,jj-1);
        K(2*(precast_beam_number*(jj-1)+ii)-2,2*(precast_beam_number*(jj-1)+ii)-1)=0;
        K(2*(precast_beam_number*(jj-1)+ii)-1,2*(precast_beam_number*(jj-1)+ii)-1)=24*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3+spring_stiffness_matrix(ii-1,jj-1)+spring_stiffness_matrix(ii,jj-1);
        K(2*(precast_beam_number*(jj-1)+ii),2*(precast_beam_number*(jj-1)+ii)-1)=0;
        K(2*(precast_beam_number*(jj-1)+ii)+1,2*(precast_beam_number*(jj-1)+ii)-1)=-spring_stiffness_matrix(ii,jj-1);
        K(2*(precast_beam_number*(jj-1)+ii)+2,2*(precast_beam_number*(jj-1)+ii)-1)=0;
        K(2*(precast_beam_number*(jj-1)+ii)-1+2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii)-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
        K(2*(precast_beam_number*(jj-1)+ii)+2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii)-1)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
        
        K(2*(precast_beam_number*(jj-1)+ii)-1-2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii))=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
        K(2*(precast_beam_number*(jj-1)+ii)-2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii))=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
        K(2*(precast_beam_number*(jj-1)+ii)-1,2*(precast_beam_number*(jj-1)+ii))=0;
        K(2*(precast_beam_number*(jj-1)+ii),2*(precast_beam_number*(jj-1)+ii))=8*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
        K(2*(precast_beam_number*(jj-1)+ii)-1+2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii))=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
        K(2*(precast_beam_number*(jj-1)+ii)+2*precast_beam_number,2*(precast_beam_number*(jj-1)+ii))=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    end
    
    %the last nodes in the middle columns
    K(2*precast_beam_number*jj-1-2*precast_beam_number,2*precast_beam_number*jj-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*precast_beam_number*jj-2*precast_beam_number,2*precast_beam_number*jj-1)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*jj-3,2*precast_beam_number*jj-1)=-spring_stiffness_matrix(precast_beam_number-1,jj-1);
    K(2*precast_beam_number*jj-2,2*precast_beam_number*jj-1)=0;
    K(2*precast_beam_number*jj-1,2*precast_beam_number*jj-1)=24*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3+spring_stiffness_matrix(precast_beam_number-1,jj-1);
    K(2*precast_beam_number*jj,2*precast_beam_number*jj-1)=0;
    K(2*precast_beam_number*jj-1+2*precast_beam_number,2*precast_beam_number*jj-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*precast_beam_number*jj+2*precast_beam_number,2*precast_beam_number*jj-1)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    
    K(2*precast_beam_number*jj-1-2*precast_beam_number,2*precast_beam_number*jj)=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*jj-2*precast_beam_number,2*precast_beam_number*jj)=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*precast_beam_number*jj-1,2*precast_beam_number*jj)=0;
    K(2*precast_beam_number*jj,2*precast_beam_number*jj)=8*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*precast_beam_number*jj-1+2*precast_beam_number,2*precast_beam_number*jj)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*precast_beam_number*jj+2*precast_beam_number,2*precast_beam_number*jj)=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
end

for ii=1:precast_beam_number  %the nodes in the last column
    K(2*(precast_beam_number*(node_number-1)+ii)-1-2*precast_beam_number,2*(precast_beam_number*(node_number-1)+ii)-1)=-12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*(precast_beam_number*(node_number-1)+ii)-2*precast_beam_number,2*(precast_beam_number*(node_number-1)+ii)-1)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*(precast_beam_number*(node_number-1)+ii)-1,2*(precast_beam_number*(node_number-1)+ii)-1)=12*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^3;
    K(2*(precast_beam_number*(node_number-1)+ii),2*(precast_beam_number*(node_number-1)+ii)-1)=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    
    K(2*(precast_beam_number*(node_number-1)+ii)-1-2*precast_beam_number,2*(precast_beam_number*(node_number-1)+ii))=6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*(precast_beam_number*(node_number-1)+ii)-2*precast_beam_number,2*(precast_beam_number*(node_number-1)+ii))=2*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
    K(2*(precast_beam_number*(node_number-1)+ii)-1,2*(precast_beam_number*(node_number-1)+ii))=-6*elasticity_modulus*moment_of_inertia_precast_beam/segment_length^2;
    K(2*(precast_beam_number*(node_number-1)+ii),2*(precast_beam_number*(node_number-1)+ii))=4*elasticity_modulus*moment_of_inertia_precast_beam/segment_length;
end

%cross out constrainted degrees of freedom
for ii=2*precast_beam_number*node_number-1:-2:2*precast_beam_number*(node_number-1)+1
    K(:,ii)=[];
    K(ii,:)=[];
end
for ii=2*precast_beam_number-1:-2:1
    K(:,ii)=[];
    K(ii,:)=[];
end
end