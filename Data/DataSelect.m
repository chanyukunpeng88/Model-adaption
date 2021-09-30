function [Xm,Ym,Xs,Ys,wavelength]=DataSelect(dataparam)
%%  corn dataset (available at http://www.eigenvector.com/data/Corn/)
%%  Rice dataset (available at https://data.mendeley.com/datasets/zvgy65m2rc/1). 
dataset=dataparam.dataset;
component=dataparam.component;
type=dataparam.type;
switch dataset
    case 1
        load corn.mat;
        switch type
            case 1
                Xm=m5spec.data;
                Xs=mp6spec.data;
            case 2
                Xm=m5spec.data;
                Xs=mp5spec.data;
            case 3
                Xm=mp5spec.data;
                Xs=mp6spec.data;
            case 4
                Xm=mp5spec.data;
                Xs=m5spec.data;
            case 5
                Xm=mp6spec.data;
                Xs=mp5spec.data;
            case 6
                Xm=mp6spec.data;
                Xs=m5spec.data;
        end
        wavelength=1100:2:2498;
        Ytemp=propvals.data;
        Y=Ytemp(:,component);
        Ym=Y;
        Ys=Y;   

    case 2
        load('Rice Kernels.mat');
        switch type
            case 1
                Xm=X1;
                Xs=X2;
                Ys=Y;
                Ym=Y;
            case 2
                Xm=X1;
                Xs=X3;
                Ys=Y;
                Ym=Y;
            case 3
                Xm=X2;
                Xs=X3;
                Ys=Y;
                Ym=Y;
        end
        wavelength=Wavelength;
end
