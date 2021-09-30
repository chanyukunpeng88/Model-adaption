close all;
clear;  clc;
addpath(genpath('Data'),genpath('PLS'),genpath('VSSOM'));
dataset=2;
component=1;
dataparam=struct('dataset',dataset,'component',component,'type',2);
[Xm,Ym,Xs,Ys,wavelength]=DataSelect(dataparam);
Result=VSSOM(Xm,Ym,Xs,Ys);
save('Result_ricekernel_type_2.mat');
figure
plot(Ys,Result.PTstS_M,'r*','MarkerSize',5,'MarkerFaceColor','r');
hold on;
plot(Ys,Result.PTstS,'b.','MarkerSize',5,'MarkerFaceColor','b');
offset=0.5;
Min=min([Ys;Result.PTstS_M;Result.PTstS])-offset;
Max=max([Ys;Result.PTstS_M;Result.PTstS])+offset;
line([Min Max],[Min Max],'Color','k');
xlim([Min Max]);
ylim([Min Max]);
str1=['No calibration transfer','   (RMSEP=',num2str(Result.RMSEtstS_M),')'];
str2=['VSSOM','   (RMSEP=',num2str(Result.RMSEP),')'];
legend(str1,str2,'Location','Northwest');
xlabel('Measured Value of Slave Insturment','Fontsize',8,'FontName','Times New Roman');
ylabel('Predicted Value of Slave Instrument','Fontsize',8,'FontName','Times New Roman');
save('Result_Ricekernel.mat');