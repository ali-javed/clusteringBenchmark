function [data,labels] = importdataset(datasetName)
dataPath = '../../data/UCRArchive_2018_unprotected_original/';
train_name = strcat(dataPath,datasetName,'/',datasetName,'_TRAIN.tsv');
test_name = strcat(dataPath,datasetName,'/',datasetName,'_TEST.tsv');

delimiter = '\t';

train_data = dlmread(train_name, delimiter);
test_data = dlmread(test_name, delimiter);

data = [train_data;test_data];

labels = data(:,1);
data(:,1) = [];
