close all;
clear;  clc;
addpath(genpath('Data'),genpath('PLS'),genpath('VSSOM'));
dataset=1;
Y=[];
for component=1:4
    dataparam=struct('dataset',dataset,'component',component,'type',1);
    [Xm,Ym,Xs,Ys,wavelength]=DataSelect(dataparam);
    Result{component}=VSSOM(Xm,Ym,Xs,Ys);
    Y=[Y Ys];
end


save('Result_Corn_type_1.mat');



StrComponent={'Moisture','Oil','Protein','Starch'};
textstr={'A','B','C','D','E','F'};
figure
for i=1:4
    subplot(2,2,i);
    plot(Y(:,i),Result{i}.PTstS_M,'r*','MarkerSize',5,'MarkerFaceColor','r');
    hold on;
    plot(Y(:,i),Result{i}.PTstS,'b.','MarkerSize',5,'MarkerFaceColor','b');
    offset=0.5;
    Min=min([Y(:,i);Result{i}.PTstS_M;Result{i}.PTstS])-offset;
    Max=max([Y(:,i);Result{i}.PTstS_M;Result{i}.PTstS])+2;
    line([Min Max],[Min Max],'Color','k');
    xlim([Min Max]);
    ylim([Min Max]);
    str1=['No calibration transfer','   (RMSEP=',num2str(Result{i}.RMSEtstS_M),')'];
    str2=['VSSOM','   (RMSEP=',num2str(Result{i}.RMSEP),')'];
    legend(str1,str2,'Location','Northwest');
    text(Min-offset,Max,textstr{i},'Rotation',0,'Fontsize',8,'FontWeight','bold');
    xlabel(['Measured Value of ', StrComponent{i}],'Fontsize',8,'FontName','Times New Roman');
    ylabel(['Predicted Value of ', StrComponent{i}],'Fontsize',8,'FontName','Times New Roman');
end
