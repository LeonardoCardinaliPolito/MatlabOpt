# MatlabOpt
Matlab course project

LEONARDO 12/3/2024
- Transformed the script as a whole in a function
- now instead of cycles for each frequency point of the scattering parameter operations are performed to the whole array of frequencies
- preallocations implemented
- getAllfiels.m function implemented
- sii_to_zero.m added to the folder
- now self-terms of the matrix are not computed (no more need to remove zeros at the end of the function)
- S_RI and S_MI cancelled, since useless
- looping throug folders, sub-folders, sub-sub-folders is deleted
- phase no more accounted for, only module
- DATA_SET, TEST_SET, DATA_SET_mod, TEST_SET_mod, now have a measurements per COLUMN (instead of rows)