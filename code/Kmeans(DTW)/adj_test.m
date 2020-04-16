gt_1  = [1 1 2 2 3 3 4 4];
pred_1 = [2 2 3 3 4 4 1 1];



gt_2 = [1 1 1 1];
pred_2 = [1 2 3 4];

gt_3 = [1 2 3 4];
pred_3 = [1 1 1 1];

gt_4 = [1 1 2 2];
pred_4 = [1 1 1 2];



[AR,RI,MI,HI] = RandIndex(gt_1,pred_1);
[AR2,RI2,MI,HI] = RandIndex(gt_2,pred_4);
[AR3,RI3,MI,HI] = RandIndex(gt_3,pred_4);
[AR4,RI4,MI,HI] = RandIndex(gt_4,pred_4);

    
disp(strcat('Rand Index: ',num2str(RI)));
disp(strcat('Adj Rand Index: ',num2str(AR)));
   
disp(strcat('Rand Index 2: ',num2str(RI2)));
disp(strcat('Adj Rand Index 2: ',num2str(AR2)));

disp(strcat('Rand Index 3: ',num2str(RI3)));
disp(strcat('Adj Rand Index 3: ',num2str(AR3)));

disp(strcat('Rand Index 4: ',num2str(RI4)));
disp(strcat('Adj Rand Index 4: ',num2str(AR4)));