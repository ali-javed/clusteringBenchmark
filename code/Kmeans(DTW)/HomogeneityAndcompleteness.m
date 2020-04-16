function [homogeneity, completeness]= HomogeneityAndcompleteness(true, pred)

homogeneity = 1 -  ( H(true,pred) / H1(true));

completeness = 1 - ( H(pred,true) / H1(pred));

end

function sum = H(C,K)
unique_classes = unique(C);
unique_clusters = unique(K);
sum = 0;
for i = 1:length(unique_classes)
    for j=1:length(unique_clusters)
        class_num = unique_classes(i);
        cluster_num = unique_clusters(j);
        
        n_c = find(C==class_num);
        n_k = find(K==cluster_num);
        
        n_ck = intersect(n_c,n_k);
        
        n_c = length(n_c);
        n_k = length(n_k);
        n_ck = length(n_ck);
        
        temp = (n_ck / length(C)) * log(n_ck /n_k);
        if isnan(temp)
            temp = 0;
        end
        
        sum = sum+temp;
        
    end
    
end

sum = sum*-1;
end



function sum = H1(C)
unique_classes = unique(C);
sum = 0;
for i = 1:length(unique_classes)
        class_num = unique_classes(i);
        
        n_c = find(C==class_num);
        
        n_c = length(n_c);
        temp = n_c / length(C) * log(n_c /length(C));
        
        sum = sum+temp;
        
end
    

sum = sum*-1;
end
