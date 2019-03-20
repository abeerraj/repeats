function [solver_names,solver_list,colormap,color_list] = make_solver_list()
solver_names = {'$\mH2\vl\vu s_{\vu}\lambda$', ...
                '$\mH22\vl\vu\vv s_{\vv}\lambda$', ...
                '$\mH22\vl s_i$', ...
                '$\mH22\lambda$', ...
                '$\mH22\vl$', ...
                '$\mH222\vl\lambda$', ...
                '$\mH32\vl\lambda$', ...
                '$\mH4\vl\lambda$', ...
                '$\mH^{\prime}222\vl\lambda$', ...
                '$\mH^{\prime}32\vl\lambda$', ...
                '$\mH^{\prime}4\vl\lambda$'}; 

solver_list = [ ...
    WRAP.laf2_to_qlsu() ...
    WRAP.laf22_to_qlusv() ...
    WRAP.laf22_to_l('solver_type','linear'), ...        
    WRAP.laf22_to_qH() ...
    WRAP.laf22_to_l('solver_type','polynomial'), ... 
    WRAP.laf222_to_ql() ...
    WRAP.laf32_to_ql() ...
    WRAP.laf4_to_ql() ...
    WRAP.laf222_to_ql('solver', 'ijcv19') ...
    WRAP.laf32_to_ql('solver', 'ijcv19') ...
    WRAP.laf4_to_ql('solver', 'ijcv19') ] ; 

color_list = [0 0 0; ...    
              0   0 255; ...
              0 255 0; ...
              255 0 0; ...
              0   0 128; ...
              0 128 0; ...
              128 0 0;
              255 140 0; ...
              0 255 255; ...
              255 0 255; ...
              255 255 0 ] /255;
    
colormap = containers.Map(solver_names, [ 8:11 1:7 ]);
