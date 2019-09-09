function [solver_names,solver_list,colormap,linestylemap] = make_stability_solver_list()
solver_names = {
    '$\mH^{\prime}2\vl\vu \lambda$', ...
    '$\mH2\vl\vu \lambda$ (det)', ...
    '$\mH2\vl\vu s_{\vu}\lambda$ (det)', ...
    '$\mH22\vl\vu\vv \lambda$ (det)', ...
    '$\mH22\vl\vu\vv s_{\vv}\lambda$ (det)', ... 
    '$\mH2\vl\vu \lambda$ (gb)', ...
    '$\mH2\vl\vu s_{\vu}\lambda$ (gb)', ...
    '$\mH22\vl\vu\vv \lambda$ (gb)', ...
    '$\mH22\vl\vu\vv s_{\vv}\lambda$ (gb)' };

solver_list = [ ...
    WRAP.laf2_to_ql() ...
    WRAP.laf2_to_qlu() ...
    WRAP.laf2_to_qlsu() ...
    WRAP.laf22_to_qluv() ...
    WRAP.laf22_to_qlusv() ...
    WRAP.laf2_to_qlu('gb') ...
    WRAP.laf2_to_qlsu('gb') ...
    WRAP.laf22_to_qluv('gb') ...
    WRAP.laf22_to_qlusv('gb') ];

color_list = [0 0 0; ...
              0 0 1; ...
              0 1 0; ...
              1 0 0; ...
              1 0 1; ...
              0 0 1; ...
              0 1 0; ...
              1 0 0; ...
              1 0 1];                    


%solver_names = solver_names(1:1);
%solver_list = solver_list(1:1);
%%
%linestylemap  = [];
%colormap = [];

tst = mat2cell(color_list,ones(9,1),3);
colormap = containers.Map(solver_names, tst);

linestylemap = ...
    containers.Map(solver_names, ...
                   { '-','-','-', ...
                    '-','-','--', ...
                    '--','--','--'});
