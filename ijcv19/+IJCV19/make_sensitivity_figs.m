function [] = make_sensitivity_figs()
[solver_names,solver_list,colormap,color_list] = IJCV19.make_solver_list();

src_path = 'ct_sensitivity_20190309.mat';
target_path = '/home/jbpritts/Documents/ijcv19/fig2/';

TEST.make_cdf_warp_fig(src_path, ...
                       target_path, ...
                       colormap, ...
                       color_list)

TEST.make_sensitivity_figs(src_path, ...
                           target_path, ...
                           colormap, ...
                           color_list,'ct');

src_path = 'rt_sensitivity_20190309.mat';
TEST.make_sensitivity_figs(src_path, ...
                           target_path, ...
                           colormap, ...
                           color_list,'rt');
