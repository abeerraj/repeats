function u = affpt_to_pt3x3(affpt)
u = LAF.A_to_pt3x3(LAF.affpt_to_A(affpt));
