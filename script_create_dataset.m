close all
clear 
clc

save_name="test";

profile on

%parentFolder = 'C:\Users\d058003\OneDrive - Politecnico di Torino\Documenti\GitHub\MatlabOpt';
parentFolder = 'C:\Users\d105457\Documents\GitHub\MatlabOpt';

ML_datacreator_6p_TOIMPROVE(save_name,parentFolder);

profile off
profile viewer
