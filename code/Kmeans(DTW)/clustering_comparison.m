function [ B ] = clustering_comparison( C1,C2 )
% [ B ] = Hclustering_comparison( C1,C2 )
%
% The function calculates the comparison measure B between two hierarchical
% partitions proposed in the paper:
% A Method for Comparing Two Hierarchical Clusterings, E. B. Fowlkes and C. L. Mallows
% JASA, 1983.
%
% INPUT:
% C1 and C2 are the vectors of clusters, arbitrarily labeled, obtained in
% two different hierarchical clustering analysis on the same observations.

% OUTPUT:
% B is the similarity index proposed.
% B=1 perfect matching between the two partitions
% B=0 no matching between the two partitions

M=crosstab(C1,C2);
Mi=sum(M,2);
Mj=sum(M,1);
n=sum(M(:));

T=sum(M(:).^2)-n;

P=sum(Mi(:).^2)-n;

Q=sum(Mj(:).^2)-n;

B= T/sqrt(P*Q);


end

