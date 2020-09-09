function [C] = get_damping_matrix(M, K)
%GET_DAMPING_MATRIX
%build Rayleigh damping matrix by setting the first and third-order mode damping ratio as 5%
%input:
%     M  --  mass matrix
%     K  --  stiffness matrix
%output:
%     C  --  Rayleigh damping matrix

syms omega_n  %natural frequencies
omega_n = double(solve(det(K-omega_n^2*M)==0,omega_n));
omega_n = unique(abs(omega_n));

%Rayleigh damping matrix
a0 = 2*0.05 / (omega_n(1)+omega_n(3)) * omega_n(1)*omega_n(3);
a1 = 2*0.05/ (omega_n(1)+omega_n(3));
C = a0*M + a1*K;
end

