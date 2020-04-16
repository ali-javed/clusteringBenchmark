function [ B, BZ, pvalue ] = PermTest_cluster_comparison( X,C,K,link,metric)

% [ B, BZ, pvalue ] = PermTest_cluster_comparison( X,C,K,link,metric)
%
%
% The function performs the permutation test on comparison measure B between two hierarchical
% partitions proposed in the paper:
% A Method for Comparing Two Hierarchical Clusterings, E. B. Fowlkes and C. L. Mallows
% JASA, 1983.
%
% Null Hypothesis of the test is: The two hierarchical partitions (C and
% CZ) are completly uncorrelated, in other word, are completly different.
%
% Alternative Hypothesis is: The two hierarchical partitions are
% correlated, in other word, have significant similarity.
%
% 
% INPUT:
% X is the original data matrix (N units x P variables)
% C is the vectors of clusters, arbitrarily labeled, obtained by theoretical assumption
%       (C represents the partition of the N objects under the Null
%       Hypothesis)
% K is a scalar indicating the number of permutations 
% link is a string indicating the method for hierarchical clustering (see
%           matlab built-in LINKAGE function help) 
%           i.e. link='average'
% metric is a string indicating the metric for hierarchical clustering (see
%           matlab built-in LINKAGE function help)
%           i.e. metric='jaccard'
%
% OUTPUT:
% B is a vector of B measures calculated on each permutated sample
% BZ is the B measure calculated among clustering on original data matrix and clustering C under null hypothesis 
% pvalue is the P-value of B measure (on original matrix) calculated by permutation test.

[n,p]=size(X);

maxC=length(unique(C));

%% cluster comparison between original matrix and null hypothesis

    Z=linkage(X,'average','jaccard');
    
    CZ(:,1)=cluster(Z,'maxclust',maxC);  % CZ is the partition obtained on original data
    
    [ BZ ] = clustering_comparison( CZ,C );


%% Permutation test
for k=1:K
    
    K_index=randperm(n);

    Xb=X(K_index,:);
    
    Zb=linkage(Xb,'average','jaccard');
    
    Cb(:,k)=cluster(Zb,'maxclust',maxC);
    
    [ B(k,1) ] = clustering_comparison( Cb(:,k),C );
    
end

%% Pvalue Calculation of BZ

pvalue=sum(B>BZ)/length(B);


