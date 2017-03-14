function [G_rt,rt] = segment_motions(u,u_corr,Hinf,varargin)
cfg.sigma = 1;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});
vq_distortion = 21.026*cfg.sigma^2;

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);

M = height(u_corr);

num_codes = 1e3;

if height(u_corr) > num_codes
    ind = unique(ceil(rand(num_codes,1)*M));
else
    ind = 1:M;
end

N = numel(ind);

Hinv = inv(Hinf);
rt = [u_corr.theta(ind,:)'; u_corr.tij(ind,:)'];
invrt = Rt.invert(rt);

[aa,bb] = meshgrid(1:M,1:numel(ind));

ut_j = LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                   LAF.apply_rigid_xforms(v(:,u_corr.i(aa,:)),rt(:,bb)));
ut_i = LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                   LAF.apply_rigid_xforms(v(:,u_corr.j(aa,:)),invrt(:,bb)));

d2 = sum([ut_j-u(:,u_corr.j(aa,:)); ...
          ut_i-u(:,u_corr.i(aa,:))].^2);
d2 = reshape(d2,M,N);

K = double(d2 < vq_distortion);
is_valid_ii = find(any(K,2));
is_valid_jj = find(any(K,1));
K = K(is_valid_ii,is_valid_jj);

w0 = lp_vq(K);
w = rm_duplicate_codes(K,w0);

code_ind = is_valid_jj(find(w>0));
d2c = d2(:,code_ind);
[min_d2c,G] = min(d2c,[],2);

G(min_d2c > vq_distortion) = nan;

G_rt = findgroups(find(G));

theta_uw = msplitapply(@(theta)  unwrap(theta), u_corr.theta, G_rt);
u_corr{~isnan(G_rt),'theta'} = theta_uw(~isnan(G_rt));

rt = cmp_splitapply(@(u) mean(u,1), [u_corr.theta u_corr.tij] ,G_rt)';
G_rt = reshape(G_rt,[],1);
