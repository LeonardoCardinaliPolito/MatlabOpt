function S = sii_to_zero(S,port_quantity, f_quantity)
%this function takes in input a sparameter object S obtained using the
%function S=sparameters(filename) and gives in output the same object with
%the self parameters (diagonals of the S4x4 matrix) put to 0

%for the first frequency in case of 6 ports Real and imaginary parts of
%reflection coefficient is as follows:

%S11 1st/2nd S22 15th/16th S33 29th/30th S44 43th/44th S55 57th/58th S66 71th/72th 
%element in the list so it increases by 14 or (port_quantity+1)*2 

skip = (port_quantity+1)*2;
S_matrix_size = (port_quantity^2)*2;%*2 becaue there are im and real values

f = 0:S_matrix_size: (S_matrix_size*(f_quantity-1));

Ref_Coef_real = 1:skip:(S_matrix_size-1);
Ref_Coef_im = 2:skip:S_matrix_size+f;

All_Ref_Coef = [Ref_Coef_real+f';Ref_Coef_im+f'];


S(All_Ref_Coef)=[];
end
