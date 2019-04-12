%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RectSolver < handle & matlab.mixin.Heterogeneous
    properties
        mss = [];
        sample_type = [];
    end
    
    methods
        function this = RectSolver(sample_type)
            switch sample_type
              case '2'
                this.mss = 2;
                
              case '22'
                this.mss = [2 2];
                
              case '22s'
                this.mss = [2 2];

              case '222'
                this.mss = [2 2 2];
                                
              case '32'
                this.mss = [3 2];
                
              case '4'
                this.mss = 4;
                
              otherwise
                throw('Incorrect sample type for rectifying solvers');
            end
            
            this.sample_type = sample_type;
        end
       
        function flag = is_sample_good(this,x,idx)
            flag = numel(unique([idx{:}])) == sum(this.mss);
        end    
        
        function flag = is_real(this,M,cc,varargin)
            if ~isfield(M,'q')
                q = zeros(1,numel(M));
            else
                q = [M(:).q];
            end
            l = [M(:).l];
            flag = false(1,numel(M));
            for k = 1:numel(M)
                flag(k) = isreal(q(k)) & isreal(M(k).l);
            end
        end

        function [flag,fflag,rflag] = is_model_good(this,x,idx,M,cc,varargin)
            m = [idx{:}];
            x = x(:,m(:));

            if ~isfield(M,'q')
                q = zeros(1,numel(M));
            else
                q = [M(:).q];
            end
                
            rflag = this.is_real(M,cc);
            nq = q*sum(2*cc)^2;
            qflag = (nq <= 0) & (nq > -8);
            oflag = false(size(qflag));
            flag = qflag & rflag;

            if any(flag)
                ind = find(flag);
                for k = 1:numel(ind)
                    xp = PT.ru_div(x,cc,q(ind(k)));
                    oflag(ind(k)) = ...
                        PT.are_same_orientation(xp,M(ind(k)).l); 
                end
            end         
            fflag = oflag & qflag;
            flag = flag & rflag & fflag;
        end        

        function M = fix(this,x,idx,M,varargin)
            M = [];
        end
    end
end