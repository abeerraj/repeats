function [timg,T,A] = render_rectification(x,model,img,varargin)
ind = find(~isnan(model.Gs));
v = reshape(x(:,ind),3,[]);

if model.q == 0
    [timg,T,A] = IMG.rectify(img, model.H, ...
                             'good_points', v, ...
                             'Fill', [255 255 255]', ...
                             varargin{:});
else
    [timg,T,A] = IMG.rectify(img, model.H, ...
                             'ru_xform', CAM.make_ru_div_tform(model.cc,model.q), ...
                             'good_points', v, ...
                             'Fill', [255 255 255]', ...
                             varargin{:});
end
