function [labels,tElapsed] = kmeans(data,band,K,max_iter)

   

    tStart = tic;
    %random seed
    rng(0,'twister');
    centeroid_index = randperm(size(data,1),K);
    centeroids = data(centeroid_index,:); 
    
    
    for i =1:max_iter
        labels = assign_means(data, centeroids,K,band);
        if length(unique(labels))<K
            disp('K voilated')
            break
        end
        
        centeroids = calculate_means(data, labels,K) ;

    end
    tElapsed = toc(tStart);

function [labels] = assign_means(data, centeroids,K,band)
    labels = Inf(1,size(data,1));
    
    for i = 1:size(data,1)  
        dist_to_center = Inf(1,K);
        
        %iteratively prune by updating least lower bound
        for j =1:K
            dist_to_center(j) = calculate_distance((data(i,:)),centeroids(j,:),band); % DTW distance calculate
            
        end
        [M,I] = min(dist_to_center);
        labels(i) = I;
    end
        
           
        
        

    
    
function [centeroids] = calculate_means(data, labels,K) 
centeroids = Inf(K,size(data,2));
for k = 1:K
 
    cluster_elements = data(labels==k,:);
    centeroids(k,:) = mean(cluster_elements,1);
end
        
    
