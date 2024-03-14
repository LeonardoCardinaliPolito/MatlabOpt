function S_new = sii_to_zero(S)
%this function takes in input a sparameter object S obtained using the
%function S=sparameters(filename) and gives in output the same object with
%the self parameters (diagonals of the S4x4 matrix) put to 0

x = size(S.Parameters, 1);

for i=1:x
    S.Parameters(i,i,:) = 0;
end

S_new = S;


