function [C,Theta] = pythagorean(A,B);

A2 = A^2;
B2 = B^2;
C2 = A2 + B2;
C = sqrt(C2);
Theta = asind(B/C);