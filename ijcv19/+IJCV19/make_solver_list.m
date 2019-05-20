function [solver_names,solver_list,colormap] = make_solver_list()
solver_names = { ...
    '$\mH2\vl\vu s_{\vu}\lambda$', ...
    '$\mH22\vl\vu\vv s_{\vv}\lambda$', ...
    '$\mH22\lambda$', ...
    '$\mH22\vl s_i$', ...
    '$\mH^{\prime}22$', ...
    '$\mH22\{\,\lambda\,\}_k$', ...
    '$\mH22\, \mid \, \lambda = -4$', ...
    '$\mH22\, \mid \, \lambda = -2$', ...
    '$\mH22\, \mid \, \lambda = 0$', ...   
    '$\mH22\vl$', ...
    '$\mH222\vl\lambda$', ...
    '$\mH32\vl\lambda$', ...
    '$\mH4\vl\lambda$', ...
    '$\mH^{\prime}222\vl\lambda$', ...
    '$\mH^{\prime}32\vl\lambda$', ...
    '$\mH^{\prime}4\vl\lambda$'}; 

solver_list_soa = [ ...
    WRAP.laf2_to_qlsu() ...
    WRAP.laf22_to_qlusv() ...
    WRAP.laf22_to_qH() ...
    WRAP.laf22_to_l('solver_type','linear'), ...
    WRAP.laf22_to_l('solver_type','linear'), ...        
    WRAP.laf22_to_ql(), ...
    WRAP.laf22_to_ql('QVals',-4), ...
    WRAP.laf22_to_ql('QVals',-2), ...
    WRAP.laf22_to_ql('QVals',0) ] ; 

proposed_solver_list = [ ...
    WRAP.laf22_to_l('solver_type','polynomial'), ... 
    WRAP.laf222_to_ql() ...
    WRAP.laf32_to_ql() ...
    WRAP.laf4_to_ql() ...
    WRAP.laf222_to_ql('solver', 'ijcv19') ...
    WRAP.laf32_to_ql('solver', 'ijcv19') ...
    WRAP.laf4_to_ql('solver', 'ijcv19') ];

proposed_color_list = [0 0 0; ...
                    0 0 1;...
                    0 1 0; ...
                    1 0 0; ...
                    0 1 1; ...
                    1 0 1;
                    1 1 0];
soa_color_list = [255 140 0; ...
                  139 69 19; ...
                  0 139 139; ...
                  128 128 0; ...
                  128 128 0; ...
                  0 140 140; ...
                  140 0 0; ...
                  0  140 0; ... 
                  140 140 0]/255;

m = numel(proposed_solver_list);
solver_list = [solver_list_soa proposed_solver_list]';
color_list = [soa_color_list; ...
              proposed_color_list];
tst = mat2cell(color_list,ones(size(color_list,1),1),3);
colormap = containers.Map(solver_names',tst);