clear 
close all
clc

save_name = "DATA_DIVISION_3_newscript";
%[DATA_SET, DATA_SET_abs, TEST_SET, TEST_SET_abs, TARGET_DATA, TARGET_TEST] = ML_datacreator_6p_LEO(save_name);
[DATA_SET, DATA_SET_abs, TEST_SET, TEST_SET_abs, TARGET_DATA, TARGET_TEST, FILES_LIST_data, FILES_LIST_test] = ML_datacreator_6p_TOIMPROVE(save_name);