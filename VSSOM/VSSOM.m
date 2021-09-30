function Result=VSSOM(Xm,Ym,Xs,Ys)
%% Input:
%  Xm: Spectral matrix of primary spectra
%  Ym: Measured concentration vector for primary spectra
%  Xs: Spectral matrix of secondary spectra
%  Ys: Measured concentration vector for secondary spectra



%% Output:
%          Result:  A struct contains the following fiedls
%         PTstS_M:  The predicted concentration for secondary spectra with primary
%                   calibration model PLS
%      RMSEtstS_M:  The root-mean-square error of secondary spectra with primary
%                   calibration model PLS
%           PTstS:  The predicted concentration for secondary spectra with VSSOM
%           PTrnM:  The predicted concentration for primary spectra with VSSOM
%           RMSEP:  The root-mean-square error of secondary spectra with VSSOM
%         RMSEtrn:  The root-mean-square error of primary spectra with VSSOM
%       RMSECVopt:  The optimal cross validation of root mean square error
%                   with VSSOM
%    VarSelectOpt:  The index of selected optimal spectral variables with
%                   VSSOM
%        LevelOpt:  The optimal Level in the row vector of dimension sizes [Level, Level]
%                   in the MATLAB built-in function selforgmap
%           LVopt:  The optimal number of latent variables in PLS with VSSOM


%% Built PLS based primary  calibration model with all the spectral variables
plsparam=struct('LVmax',15,'F_value',0.25,'premethod',1,'group',5);
PLS_primary= plsmod(Xm,Ym,Xs,Ys,plsparam);
%% Prediction result of secondary spectra with PLS
PTstS_M=PLS_primary.PTst;
RMSEtstS_M= PLS_primary.RMSEtst;

%% Spectral Variables Cluster
RMSEtstS_opt_temp=[];
RMSEtrnM_opt_temp=[];
LVopt_temp_opt=[];
RMSECVopt_temp_opt=[];
PTstS_temp_opt=[];
PTrnM_temp_opt=[];
coverSteps=500;
initNeighbor=3;
topologyFcn='hextop';
distanceFcn='linkdist';
for Level=2:5
    net = selforgmap([Level Level],coverSteps,initNeighbor,topologyFcn,distanceFcn);
    net1 = train(net, Xm);
    net2 = train(net, Xs);
    y1 = net1(Xm);
    y2 = net2(Xs);
    Label1 = vec2ind(y1);
    Label2 = vec2ind(y2);
    %% Split the label for each subclass
    ind1=LabelSplit(Label1,Level^2);
    ind2=LabelSplit(Label2,Level^2);
    %% Rank the intersection between each subclass of primary and secondary spectra
    [InterInd, ~] = IntersectRank(ind1,ind2);
    
    %% Calibration model of primary spectra with selected spectral variables
    for i=1:length(InterInd)
        ind=InterInd{i};
        PLS_temp= plsmod(Xm(:,ind),Ym,Xs(:,ind),Ys,plsparam);
        LVopt_temp(i)=PLS_temp.LVopt;
        PTrnM_temp{i} = PLS_temp.PTrn;
        PTstS_temp{i} = PLS_temp.PTst;
        RMSEtstS_temp(i)= PLS_temp.RMSEtst;
        RMSECVopt_temp(i)=PLS_temp.RMSECVmin;
        RMSEtrnM_temp(i)=PLS_temp.RMSEtrn;
        
    end
    
    [~,index]=min(RMSECVopt_temp);
    VarSelect{Level-1}=InterInd{index};
    RMSEtstS_opt_temp=[RMSEtstS_opt_temp RMSEtstS_temp(index)];
    RMSEtrnM_opt_temp=[RMSEtrnM_opt_temp RMSEtrnM_temp(index)];
    RMSECVopt_temp_opt=[RMSECVopt_temp_opt RMSECVopt_temp(index)];
    LVopt_temp_opt=[LVopt_temp_opt LVopt_temp(index)];
    PTstS_temp_opt=[PTstS_temp_opt PTstS_temp{index}];
    PTrnM_temp_opt=[PTrnM_temp_opt PTrnM_temp{index}];
end


[~,LevelOpt]=min(RMSECVopt_temp_opt);


RMSEtstS_opt=RMSEtstS_opt_temp(LevelOpt);
RMSEtrnM_opt=RMSEtrnM_opt_temp(LevelOpt);
RMSECVopt=RMSECVopt_temp_opt(LevelOpt);
LVopt=LVopt_temp_opt(LevelOpt);
VarSelectOpt=VarSelect{LevelOpt};
PTstS_opt=PTstS_temp_opt(:,LevelOpt);
PTrnM_opt=PTrnM_temp_opt(:,LevelOpt);
LevelOpt=LevelOpt+1;





%% Extract the result
Result.PTstS_M=PTstS_M;
Result.RMSEtstS_M=RMSEtstS_M;
Result.PTstS=PTstS_opt;
Result.PTrnM=PTrnM_opt;
Result.RMSEP=RMSEtstS_opt;
Result.RMSEtrn=RMSEtrnM_opt;
Result.RMSECVopt=RMSECVopt;
Result.VarSelectOpt=VarSelectOpt;
Result.LevelOpt=LevelOpt;
Result.LVopt=LVopt;






