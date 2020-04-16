for i=4:9
    all_1_da(i)
end


function all_1_da(run_num)

DataSummary = importdatafile();
DataSummary = sortrows(DataSummary,'Train');
Names = DataSummary.Name;

output_fname = sprintf('../../output/Kmeans_dtw_matlab_allscores_5percent_%d.csv',run_num);
row = {'Name','Time','RI','ARI','MI','HI','Mutual Information','Fowlkes Mallows Score','Homogeneity Score','Completeness Score'};

fid = fopen(output_fname,'wt');
if fid>0
    for k=1:size(row,1)
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',row{k,:});
    end
end
    fclose(fid);
    
    
    
    

for d = 1 : length(Names)
    
    
    
    dName = Names(d);
    
    disp(dName);
    
    
    [data,labels] = importdataset(dName);
    
    %skip datasets with noise all datasets with noise have k=1, not useful
    %to test clustering
    
    
    if min(labels)<0
        disp(strcat('Noise dataset ',dName));
        continue 
        
    
    end
    
   
    
    %code is not for variable lenght series
    length_series = DataSummary.Length(DataSummary.Name == dName  );
    length_series = char(length_series);
    
    if strcmp(length_series,'Vary')
        disp(strcat('Variable length dataset ',dName));
    
        continue
        
    else
        length_series = str2num(length_series);
    end
    
    
    
    K = DataSummary.Class(DataSummary.Name == dName );
    
    
    
    
    band = DataSummary.DTWlearned_w(DataSummary.Name == dName);
    band = regexp(band,'(\d+)\s+\((\d+)\)','tokens','once');
    band = char((band(2)));
    %fixed window size
    band =0.05;
    n = size(data,2);
    
    max_iter = 15;
    [clAssignment,clusterTime] = kmeans(data,band,K,max_iter);
    labels = labels+1;
    [AR,RI,MI,HI] = RandIndex(clAssignment,labels);
    
    
    [AMI_]=ami(labels,clAssignment);
    [ B ] = clustering_comparison(labels,clAssignment);
    [homogeneity, completeness]= HomogeneityAndcompleteness(labels, clAssignment);
    row = {dName,num2str(clusterTime),RI,AR,MI,HI,AMI_,B,homogeneity,completeness};
    fid = fopen(output_fname,'a');
    if fid>0
        for k=1:size(row,1)
            fprintf(fid,'%s,%s,%f,%f,%f,%f,%f,%f,%f,%f\n',row{k,:});
        end
    end
    fclose(fid);
    disp(dName);
    disp(AR);
    
   
    
end
end

    
