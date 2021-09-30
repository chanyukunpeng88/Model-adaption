function model= plsmod(XTrn,YTrn,XTst,YTst,plsparam)
%% Input:
%% XTrn:  spectral matrix in train set;
%% YTrn:  response martix in train set;
%% XTst:  spectral matrix in test set;
%% YTst:  response matrix in test set;

%%  Output:
%%   model: the result of model;



%% Extract parameters of PLS model
%% LVmax: The maximum number of PLS
LVmax=plsparam.LVmax;
%%   F_value: Parameter in F test to determine the number of LVs
F_value=plsparam.F_value;
%%     group: the k-fold crossvalidation;
group=plsparam.group;
%%    premethod: the preprocessing method
premethod=plsparam.premethod;
%% cross validation of pls model building;
RMSECV=plsCV(XTrn,YTrn,LVmax,1,'syst123',group);

%%  find the optimal number of principal components;
LVopt=FindPC(RMSECV,length(YTrn),'Ftest_RMSECV',F_value);

%% Establish the optimal PLS model
Result= pls2reg(XTrn, YTrn,XTst,YTst, LVopt, premethod);

%% Extract the modeling result
PTrn=Result.PTrn{1,LVopt};
ntrn=length(YTrn);
RMSEtrn=sqrt(sum((PTrn-YTrn).^2)/ntrn);
PTst=Result.PTst{1,LVopt};
ntst=length(YTst);
RMSEtst=sqrt(sum((PTst-YTst).^2)/ntst);
model.PTrn=PTrn;
model.PTst=PTst;
model.RMSEtrn_total=Result.RMSEtrn(LVopt);
model.RMSEtsttotal=Result.RMSEtst(LVopt);
model.LVopt=LVopt;
model.B=Result.B{1,LVopt};
model.RMSECVmin=RMSECV(LVopt);
model.RMSECV=RMSECV;
model.RMSEtrn=RMSEtrn;
model.RMSEtst=RMSEtst;





