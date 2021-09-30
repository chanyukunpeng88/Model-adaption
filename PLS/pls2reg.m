function Result= pls2reg(XTrn, YTrn, XTst, YTst,PC, premethod)
%% The code are written for multiple response variables

%%      Input:
%%       XTrn: Spectral matrix of training set
%%       YTrn: Concentration matrix of training set
%%       XTst: Spectral matrix of test set
%%       YTst: Concentration matrix of test set
%%         PC: The number of principal components
%%  premethod: The preprocessing method

%%  Output:
%%  Result: A struct containing the corresponding result

if nargin < 6
    premethod = 1;
end

if nargin < 5
    PC = 10;
end

%% Meancenter
[ntrn,p]= size(XTrn);
PC=min([p,PC]);
m=size(YTrn,2);
if premethod == 1
    Xuse  = XTrn - ones(ntrn,1)*mean(XTrn);
    Yuse  = YTrn - ones(ntrn,1)*mean(YTrn);
    %% Standard
elseif premethod == 2
    Xuse  = (XTrn - ones(ntrn,1)*mean(XTrn))./ (ones(ntrn,1)*std(XTrn));
    Yuse  = (YTrn - ones(ntrn,1)*mean(YTrn))./ (ones(ntrn,1)*std(YTrn));
end

%% Main function on PLS regression coefficient B;
PVE=zeros(2,PC);
for i = 1 : PC
    stopcond = 0;
    u = Yuse(:,1);
    while ~stopcond
        w = Xuse'*u;
        w = w / sqrt(w'*w);
        t = Xuse*w;
        q= (Yuse'*t)/(t'*t);
        q=q/sqrt(q'*q);
        unew = (Yuse*q)/(q'*q);
        diff = (u-unew)'*(u-unew);
        if diff < eps
            stopcond = 1;
        end
        u = unew;
    end
    
    p = (Xuse'*t) / (t'*t);
    b(i)=(t'*u)/(t'*t);
    Xuse = Xuse - t*p';
    Yuse = Yuse - b(i)*t*q';
    W(:,i) = w;
    T(:,i) = t;
    P(:,i) = p;
    Q(:,i) = q;
    U(:,i) = u;
    R(:,i)=b(i)*t;
    B{1,i} = W(:, 1:i) * inv(P(:,1:i)'*W(:, 1:i)+10^(-6)*eye(i)) *diag(b(1:i))* Q(:,1:i)';
    
end

%% Calculate the predicted values of the training set and test set, respectively;
PTrn =cell(1,PC);
ntst = size(XTst,1);
PTst = cell(1,PC);
RMSEtrn=zeros(1,PC);
RMSEtst=zeros(1,PC);

switch premethod
    %% Meancenter
    case 1
        XTrnm=XTrn-ones(ntrn,1)*mean(XTrn);
        XTstm=XTst-ones(ntst,1)*mean(XTrn);
        for i=1:PC
            PTrn{1,i}= XTrnm*B{1,i}+ones(ntrn,1)*mean(YTrn);
            PTst{1,i}= XTstm*B{1,i}+ones(ntst,1)*mean(YTrn);
            Errtrain=(YTrn - PTrn{1,i}).^2;
            RMSEtrn(1,i) = sqrt( sum( Errtrain(:)) /(ntrn*m));
            Errtest=(YTst - PTst{1,i}).^2;
            RMSEtst(1,i) = sqrt( sum( Errtest(:)) /(ntst*m));
        end
        
        %% Standard
    case 2
        XTrnms=(XTrn-ones(ntrn,1)*mean(XTrn))./(ones(ntrn,1)*std(XTrn));
        XTstms=(XTst-ones(ntst,1)*mean(XTrn))./(ones(ntst,1)*std(XTrn));
        for i=1:PC
            PTrn{1,i}= XTrnms*B{1,i}*std(YTrn)+ones(ntrn,1)*mean(YTrn);
            PTst{1,i}= XTstms*B{1,i}*std(YTrn)+ones(ntst,1)*mean(YTrn);
            Errtrain=(YTrn - PTrn{1,i}).^2;
            RMSEtrn(1,i) = sqrt( sum( Errtrain(:)) /(ntrn*m));
            Errtest=(YTst - PTst{1,i}).^2;
            RMSEtst(1,i) = sqrt( sum( Errtest(:)) /(ntst*m));
        end
end


%% Exact result:
Result.PTrn=PTrn;
Result.PTst=PTst;
Result.RMSEtrn=RMSEtrn;
Result.RMSEtst =RMSEtst;
Result.W   = W;
Result.T   = T;
Result.U  =U;
Result.P = P;
Result.Q = Q;
Result.B  = B;
Result.R=R;


