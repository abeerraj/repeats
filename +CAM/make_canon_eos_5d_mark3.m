%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [K nx ny ccd_sz f] = make_canon_eos_5d_mark3(ef)
nx = 5760;
ny = 3840;
cc = [nx/2 ny/2];
alpha_c = 0;
ccd_sz = [36*10^-3 24*10^-3]; 
px_sz = ccd_sz./[nx ny];
s = CAM.get_crop_factor(ccd_sz);
f = ef/s;
K = CAM.make_K(f,cc,alpha_c,px_sz);