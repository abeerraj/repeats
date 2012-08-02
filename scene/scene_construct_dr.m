function dr = scene_construct_dr(geom, sift, id, gid, s, ...
                                 num_dr, name, subgenid, subtype)
if nargin < 1
dr = struct('geom',{}, ...
            'u',{}, ...
            'sifts',{}, ...
            'id',{}, ...
            'gid',{}, ...
            's',{}, ...
            'num_dr',{}, ...
            'name',{}, ... 
            'subgenid',{}, ...
            'subtype',{});
else
dr = struct('geom', geom, ...
            'u',{}, ...
            'sifts', sift, ...
            'id', id, ...
            'gid', gid, ...
            's', s, ...
            'num_dr', num_dr, ...
            'name', name, ... 
            'subgenid', subgenid, ...
            'subtype', subtype);
end