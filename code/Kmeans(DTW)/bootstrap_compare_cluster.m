function [ B M_SE CI] = bootstrap_compare_cluster( X, C, K, link,metric)
%
% [ B M_SE IC] = bootstrap_compare_cluster( X, C, K)
%
%
% The function calculates the bootstrap confidence interval of B measure  proposed in the paper:
% A Method for Comparing Two Hierarchical Clusterings, E. B. Fowlkes and C. L. Mallows
% JASA, 1983.
%
%  
% INPUT:
% X is the original data matrix (N units x P variables)
% C is the vectors of clusters, arbitrarily labeled, obtained by theoretical assumption
% K is a scalar indicating the number of bootstrap replications
% link is a string indicating the method for hierarchical clustering (see
%           matlab built-in LINKAGE function help) 
%           i.e. link='average'
% metric is a string indicating the metric for hierarchical clustering (see
%           matlab built-in LINKAGE function help)
%           i.e. metric='jaccard'
%
% OUTPUT:
% B is a vector of B measures calculated on each bootstrap sample
% M_SE contains Bootstrap Expected Value and Standard Erorr of B
% CI contains the 95% bootstrap confidence interval boundaries of B
% measure.



[n,p]=size(X);
 
maxC=length(unique(C));

K_index=floor(unifrnd(0,p,p,K))+1;  %% K bootstrap samples


%% bootstrap procedure
for k=1:K

    Xb=X(:,K_index(:,k));
    
    Zb=linkage(Xb,link,metric);
    
    Cb(:,k)=cluster(Zb,maxC);
    
    [ B(k,1) ] = clustering_comparison( Cb(:,k),C );
    
end

M_SE=[mean(B) std(B)];
CI=[prctile(B,5) prctile(B,95)];

