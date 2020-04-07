# maths
import numpy as np

from sklearn.metrics import adjusted_rand_score
from sklearn.metrics import adjusted_mutual_info_score
from collections import defaultdict
from sklearn import metrics
import csv
import os
from scipy.misc import comb
from itertools import combinations
import time

#warning while calculating adjusted rand score
import warnings
warnings.filterwarnings('ignore')


#import algorithms
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import KMeans
from skfuzzy.cluster import cmeans


def rand_index_score(clusters, classes):
    tp_plus_fp = comb(np.bincount(clusters), 2).sum()
    tp_plus_fn = comb(np.bincount(classes), 2).sum()
    A = np.c_[(clusters, classes)]
    tp = sum(comb(np.bincount(A[A[:, 0] == i, 1]), 2).sum()
             for i in set(clusters))
    fp = tp_plus_fp - tp
    fn = tp_plus_fn - tp
    tn = comb(len(A), 2) - tp - fp - fn
    return (tp + tn) / (tp + fp + fn + tn)


#metadata file path (e.g., K and number of observations)
fname_path = '../data/DataSummary.csv'
metadata =defaultdict(lambda:{})
csvr = csv.DictReader(open(fname_path))
names = []
length = []
for r in csvr:
    names.append(r['Name'])
    length.append(int(r['Train ']))

    for fieldname in csvr.fieldnames:
        metadata[r['Name']][fieldname] = r[fieldname]
    
#sort for smallest datasets first as per train size
ind = np.argsort(np.asarray(length))
names_sorted = []
for i in ind:
    names_sorted.append(names[i])



for num_runs in range(0,1):

    output_fn = '../output/scores'+str(num_runs)+'.csv'
    fout = open(output_fn, "w")
    fieldnames=['dataset','adjusted Mutual Information', 'adjusted Rand index', 'Homogeneity',
                             'Completeness', 'Fowlkes Mallows', 'Rand index']
    csvw = csv.DictWriter(fout,fieldnames = fieldnames )

    csvw.writeheader()
    fout.close()
    counter_data_set = 1
    #put data path here
    dataPath = '../data/UCRArchive_2018_unprotected_original/'


    c = 0

    for d in names_sorted:
        if d != '.DS_Store' and d != 'desktop.ini':
                 
            
            print('Loading ' + d + '...')
            dataset = d+'/'
            fname = d

            
            data = []
            classes = []
            train_test = ['_TRAIN.tsv','_TEST.tsv']
            for tt in train_test:
                path = dataPath+dataset+fname+tt
                with open(path) as f:
                    reader = csv.reader(f, delimiter='\t', quoting=csv.QUOTE_MINIMAL)
                    for row in reader:
                        t = []
                        classes.append(int(row[0]))

                        for value in row[1:]:
                            #if value is not nan

                            if float(value) ==float(value):

                                t.append(float(value))
                            else:
                                t.append(0)

                    
                        data.append(t)
            
            

            
            
            data = np.asarray(data)
            
            print('data loading complete. size :'+str(np.shape(data)))
            
            
            output_row = {}
            k = len(set(classes))
            #do not classify noise
            if -1 in classes:
                k = k -1
            
            if metadata[d]['Length']=='Vary':
                continue

            max_iter = 15
            s = metadata[d]['DTW (learned_w) '].split()[1]
            
            if k==1:
                continue
            
            #switch clustering algorithms here
            
            #Agglomerative
            clustering = AgglomerativeClustering(n_clusters=k).fit(data)
            labels = clustering.labels_
            
            #Kmeans (Euclidean)
            # clustering = KMeans(n_clusters=k, random_state=0).fit(data)
            #labels = clustering.labels_
            
            #Fuzzy c-means
            #cntr, u, u0, dat, jm, p, fpc  = cmeans(np.transpose(data), c=k, m=2, error = 0.005, maxiter=100, init=None, seed=None)
            #labels = np.argmax(u, axis=0)
            
            
            
    
            
            
            MI = adjusted_mutual_info_score(classes, labels)
            RS = adjusted_rand_score(classes, labels)
            HS = metrics.homogeneity_score(classes, labels)
            CS = metrics.completeness_score(classes, labels)
            FMS = metrics.fowlkes_mallows_score(classes, labels)
            RI = rand_index_score(classes,labels)

            
            counter_data_set = counter_data_set+1
            
            output_row['dataset'] = d
            output_row['adjusted Mutual information'] = MI
            output_row['adjusted Rand index'] = RS
            output_row['Homogeneity'] = HS
            output_row['Completeness'] = CS
            output_row['Fowlkes Mallows'] = FMS
            output_row['Rand index'] = RI
    
            


            fout = open(output_fn, "a")
            csvw = csv.DictWriter(fout, fieldnames=fieldnames)
            csvw.writerow(output_row)
            fout.close()


