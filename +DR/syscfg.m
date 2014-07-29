classdef syscfg
    properties 
        genmap
        upgmap
        descmap
    end

    methods
        function this = syscfg()
            if (exist('extrema') == 3)
                tst = dr.mserp_cfg();
                this.genmap = containers.Map({'dr.mserp_cfg','dr.mserm_cfg'}, ...
                                            {'make_extrema','make_extrema'});
                this.upgmap = containers.Map({'dr.mserp_cfg:dr.laf_cfg','dr.mserm_cfg:dr.laf_cfg'}, ...
                                            {'make_mser_to_laf','make_mser_to_laf'});
                this.descmap = containers.Map('dr.laf_cfg:dr.sift_cfg','make_laf_to_sift');
            end
        end

        function gens = get_gens(this,cfg_list)
            gen_str = arrayfun(@(x) values(this.genmap,x), ...
                               arrayfun(@(x) class(x),cfg_list,'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})),gen_str,'UniformOutput',false);
            gens = [tmp{:}];
        end

        function upgs = get_upgrades(this,upg_cfg_list)
            upg_str = arrayfun(@(x) values(this.upgmap,x), ...
                               arrayfun(@(x) [class(x.prev) ':' class(x)],upg_cfg_list, ...
                                        'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})),upg_str,'UniformOutput',false);
            upgs = [tmp{:}];
        end

        function descriptors = get_descriptors(this,desc_cfg_list)
            desc_str = arrayfun(@(x) values(this.descmap,x), ...
                               arrayfun(@(x) [class(x.prev) ':' class(x)], ...
                                        desc_cfg_list, ...
                                        'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})), ...
                          desc_str,'UniformOutput',false);
            descriptors = [tmp{:}];
        end
    end
end

function extrema = make_extrema()
    extrema = dr.extrema();
end

function mser_to_laf = make_mser_to_laf()
    mser_to_laf = dr.mser_to_laf();
end

function laf_to_sift = make_laf_to_sift()
    laf_to_sift = dr.laf_to_sift();
end


%classdef mser_cfg < dr.dr_cfg
%    methods
%        function configure(obj,varargin)
%            mser_cfg = dr.mser_cfg();
%            mser_cfg = helpers.vl_argparse(mser_cfg,varargin{:})
%            mser_cfg.key = cfg2hash(mser_cfg,true);
%        end
%    end
%
%    properties
%        verbose = 1;
%        relative = 0;
%        preprocess = 1;
%        export_image = 1;
%        min_size = 30;
%        min_margin = 10;
%        max_area = 0.01;
%        use_hyst_thresh = 0;
%        low_factor = 0.9;
%        precise_border = 0;
%        subsample_to_minsize = 0;
%        chroma_thresh = 0.09;
%        min_areadiff = 0.1;
%        nms_method = 0;
%    end
%end 
%%
%function gens = get_gens(obj,dr_cfg_list)
%gens = structfun(@(x) values(genmap,x));
%end
%
%function upgs = get_upgrades(obj,feat_cfg_list,upg_cfg_list)
%for k = 1:numel(feat_cfg_list)
%    upgs(k) = upgmap([class(feat_cfg_list(k)) ':' class(upg_cfg_list(k))]);
%end
%end
%
%end
%

%region_list = [];
%if (exist('extrema')==3)
%   % define_dr('MSER+ inten.', 'extrema', 1, 'rle2poly', 'rle', {{'laf', @dr_upgrade_mser2laf, 'affpt'}, ...
%   %                     {'dg', @upgrade_mser2affpt, 'affpt'}});
%   % define_dr('MSER- inten.', 'extrema', 2, 'rle2poly', 'rle', {{'laf', @dr_upgrade_mser2laf, 'affpt'}, ...
%   %                      {'dg', @upgrade_mser2affpt, 'affpt'}});
%   region_list(1) = dr_define(dr_def,'MSERp', 'extrema', 1, 'rle2poly', 'rle', {{'dg', @upgrade_mser2affpt, 'affpt'}, {'laf', @dr_upgrade_mser2laf, 'affpt'}, {'gv', @upgrade_mser2ellpt, 'affpt'}});
%   dr_def = dr_define(dr_def,'MSERm', 'extrema', 2, 'rle2poly', 'rle', {{'dg', @upgrade_mser2affpt, 'affpt'}, {'laf', @dr_upgrade_mser2laf, 'affpt'}, {'gv', @upgrade_mser2ellpt, 'affpt'}});
%end;
%
%if (exist('kmpts2')==3 & 1)
%   dr_def = dr_define(dr_def,'LoG',             'affpts', 4, 'simpt', 'simpt', {});
%   dr_def = dr_define(dr_def,'LoG GV, DG','affpts', 4, 'trspt', 'simpt', {{'dg', @upgrade_trs2simpt, 'simpt'}});
%   dr_def = dr_define(dr_def,'Hessian Laplace', 'affpts', 3, 'simpt', 'simpt', {});
%   dr_def = dr_define(dr_def,'DoG',             'affpts', 5, 'simpt', 'simpt', {});
%   dr_def = dr_define(dr_def,'LoG Affine',      'affpts', 8, 'affpt', 'affpt', {});
%   dr_def = dr_define(dr_def,'LoG Affine GV, DG',  'affpts', 8, 'ellpt', 'ellpt', {{'dg', @upgrade_ell2affpt, 'affpt'}});
%   dr_def = dr_define(dr_def,'Hessian Affine',  'affpts', 7, 'affpt', 'affpt', {});
%   dr_def = dr_define(dr_def,'Hessian Affine GV', 'affpts', 7, 'ellpt', 'ellpt', {{'gv', @upgrade_ell2affpt_gv, 'affpt'}});
%   dr_def = dr_define(dr_def,'Selected H.Aff. GV', 'affpts_sel', 7, 'ellpt', 'ellpt', {{'gv', @upgrade_ell2affpt_gv, 'affpt'}});
%
%   dr_def = dr_define(dr_def,'Hessian GV', 'affpts', 3, 'trspt', 'trspt', {{'gv', @upgrade_trs2simpt_gv, 'simpt'}});
%   dr_def = dr_define(dr_def,'Selected Hessian GV', 'affpts_sel', 3, 'trspt', 'trspt', {{'gv', @upgrade_trs2simpt_gv, 'simpt'}});
%end;
%
%if (exist('censure')==3 & 1)
%   dr_def = dr_define(dr_def,'CenSurE trspt',   'censure_t',10, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}});
%   dr_def = dr_define(dr_def,'CenSurE simpt',   'censure_s',11, 'simpt', 'simpt', {});
%   dr_def = dr_define(dr_def,'CenSurE affpt',   'censure_a',12, 'affpt', 'affpt', {});  
%end
%
%if (exist('maver_detector')==3 & 1)
%   dr_def = dr_define(dr_def,'Salient rad',   'maver', 0, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}})
%   dr_def = dr_define(dr_def,'Salient tan',   'maver', 1, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}})
%   dr_def = dr_define(dr_def,'Salient rt',    'maver', 2, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}})
%   dr_def = dr_define(dr_def,'Salient res',   'maver', 3, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}})
%end;
%
%if (exist('star_detector')==3 & 1)
%    dr_def = dr_define(dr_def,'Star-Detector trspt',   'star_detector_t',13, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}});
%end
%
%if (exist('sfop')==3 & 1)
%    dr_def = dr_define(dr_def,'SFOP trspt',   'sfop_t',14, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}});
%end
%
%if (exist('cvsurf')==3 & 1)
%    dr_def = dr_define(dr_def,'SURF trspt',   'cvsurf_t',15, 'simpt', 'trspt', {{'dg', @upgrade_trs2simpt, 'simpt'}});
%end
%
%if 0
%   if (exist('lafsdetect','file')==3)   
%      dr_def = dr_define(dr_def,'MSAF inten.', 'lafdetector', 1, 'lafs', 'lafs');
%   end;
%
%   if (exist('edgeimg')==3)
%      dr_def = dr_define(dr_def,'MSER grad.', 'extremag', 3, 'rle2poly', 'rle');
%   end;
%
%   if (exist('extrema')==3)
%      dr_def = dr_define(dr_def,'MSER+ redblue.', 'extrema', 3, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER- redblue.', 'extrema', 4, 'rle2poly', 'rle');
%
%      dr_def = dr_define(dr_def,'MSER+ sat.', 'extrema', 5, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER- sat.', 'extrema', 6, 'rle2poly', 'rle');
%      
%      dr_def = dr_define(dr_def,'MSER+ hue', 'extrema', 7, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER- hue', 'extrema', 8, 'rle2poly', 'rle');
%
%      dr_def = dr_define(dr_def,'MSER(BD)+ inten.', 'extrema', 9, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER(BD)- inten.', 'extrema', 10, 'rle2poly', 'rle');
%      
%      dr_def = dr_define(dr_def,'MSER(SQ)+ inten.', 'extrema', 11, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER(SQ)- inten.', 'extrema', 12, 'rle2poly', 'rle');
%
%      dr_def = dr_define(dr_def,'MSER(SQ2)+ inten.', 'extrema', 13, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'MSER(SQ2)- inten.', 'extrema', 14, 'rle2poly', 'rle');
%   end;
%
%   if (exist('FH_detektor')==3 & 1)
%      %  dr_def = dr_define(dr_def,'CSER', 'cextrema', 1, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'FHER', 'fhdetect', 1, 'rle2poly', 'rle');
%   end;
%
%   if (exist('cextrema')==3 & 1)
%      %  dr_def = dr_define(dr_def,'CSER', 'cextrema', 1, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'CHER+', 'cextrema', 1, 'rle2poly', 'rle');
%      dr_def = dr_define(dr_def,'CHER-', 'cextrema', 2, 'rle2poly', 'rle');
%   end;
%
%   if (exist('affnorm')==3 & 1)
%      dr_def = dr_define(dr_def,'APTS Lapl.', 'apts', 0, 'ellipse', 'ellipse');
%      dr_def = dr_define(dr_def,'APTS Hes.', 'apts', 1, 'ellipse', 'ellipse');
%   end;
%
%   if (exist('canny')==3 & exist('closed_loops')==3 & 0)
%      dr_def = dr_define(dr_def,'CL inten.', 'closed', 1, 'loop', 'loop');
%   end;
%
%   if (exist('affnorm')==3 & 1)
%      dr_def = dr_define(dr_def,'APTS Lapl.', 'apts', 0, 'ellipse', 'ellipse');
%      dr_def = dr_define(dr_def,'APTS Hes.', 'apts', 1, 'ellipse', 'ellipse');
%   end;
%
%   if (exist('salient_maver')==2 & 1)
%      dr_def = dr_define(dr_def,'Salient Maver',   'spts', 0, 'ellsift', 'ellsift');
%   end;   
%
%   if (exist('mexswd')==3 & 1)
%      dr_def = dr_define(dr_def,'SWD points', 'swd', 1, 'ellsift', 'ellsift');   
%   end;
%
%   dr_def = dr_define(dr_def,'Lowe KPTS', 'kpts', 1, 'keypoint', 'keypoint');
%   %dr_def = dr_define(dr_def,'AffLowe', 'afflowe', 0, 'ellipse', 'ellipse');
%   %dr_def = dr_define(dr_def,'AffHybrid', 'afflowe', 1, 'ellipse', 'ellipse');
%   %dr_def = dr_define(dr_def,'AffMSER', 'afflowe', 2, 'ellipse', 'ellipse');
%   %dr_def = dr_define(dr_def,'CSEGs', 'csegs', 1, 'rle2poly', 'rle');
%
%   if (exist('gpudetect')==3 & 1)
%      dr_def = dr_define(dr_def,'GPU Harris 2D', 'gpudet', 0, 'point', 'point');
%      dr_def = dr_define(dr_def,'GPU Harris 3D', 'gpudet', 1, 'point', 'point');
%      dr_def = dr_define(dr_def,'GPU Hessian',   'gpudet', 2, 'point', 'point');
%      dr_def = dr_define(dr_def,'GPU Laplace',   'gpudet', 3, 'point', 'point');
%      dr_def = dr_define(dr_def,'GPU DoG',       'gpudet', 4, 'point', 'point');
%   end;
%
%   if (exist('lafsdetect')==3)   
%      dr_def = dr_define(dr_def,'MSAF inten.', 'lafdetector', 1, 'lafs', 'lafs');
%   end;
%
%   if (exist('detect_blobs')==3 & 0)
%      dr_def = dr_define(dr_def,'CSPTS', 'cspts', 1, 'ellipse', 'ellipse');
%   end;
%
%   if (exist('abFindFace_multiview')==3)
%      dr_def = dr_define(dr_def,'WBPTS', 'wbpts', 1, 'keypoint', 'keypoint');
%   end;
%
%   if (exist('polydetect')==3)
%      dr_def = dr_define(dr_def,'Cycles', 'cycles', 1, 'junct', 'junct');
%   end;
%end
%
%if (numel(dr_def) == 0)
%  error('Sorry no regions defined, please check MEX-file(s)\n');
%end
%
%function region = make_region(cfg,generator,upgrades)
%genmap(class(cfg)) = generator;
%
%
%region = struct('uid',uid, ...
%                'generator',detector_name, ...
%                'representation',representation, ...
%                'upgrades',upgrades);