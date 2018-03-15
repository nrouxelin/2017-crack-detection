function [J] = reduce_specularity(I,tol)
%REDUCE_SPECULARITY Reduce the specularity component of an image
%   I is the original image
%   tol is the tolerance for convergence test
%   J is the processed image

%dimensions de l'image
[nI, pI, qI] = size(I);

%initialisation de la matrice des données
k = 0;
n = qI;
p = nI*pI;
V = zeros(n, p);
for i = 1:nI
    for j = 1:pI
        k = k+1;
        V(:,k) = I(i,j,:); 
    end
end

if min(V(:,:))<0, err('Negative values'); end

V = double(V);

%dimensions des matrices correspondantes
r = 2;

%sparceness
sH1 = 0.001;
sH2 = 0.4;

%initialisation de W et H
W = rand(n,r);
H = rand(r,p);

L1 = (1-sH1)*sqrt(p)+sH1;
for l = 1:(r-1)
    H(l,:) = project(H(l,:),L1,1);
end
L1 = (1-sH2)*sqrt(p)+sH1;
H(2,:) = project(H(2,:),L1,1);


iter = 0;
muW = 0.85;
muH = 0.85;

mynorm = @(u)max(max(max(abs(u))));
err = 2*tol;

while iter<500 && err>tol;
    W = W.*(V*H')./(W*H*H');
    
    HOld = H;
    muH = 1.2*muH;
    flag = true;
    obj = mynorm(V-W*H);
            
    while flag
        H = H-muH*W'*(W*H-V);
        %projection
        L1 = (1-sH1)*sqrt(p)+sH1;
        for l = 1:(r-1)
            H(l,:) = project(H(l,:),L1,1);
        end
        L1 = (1-sH2)*sqrt(p)+sH1;
        H(r,:) = project(H(r,:),L1,1);
    
            
        if mynorm(V-W*H) < obj || muH < 1e-200
            flag = false;
        else
            muH = muH/2;
        end
    end
    
    iter = iter + 1;
    err = mynorm(HOld-H);
end


%Séparation de la composante diffuse et spéculaire de l'image
WD = zeros(n, r-1);
HD = zeros(r-1, p);

for i = 1:(r-1)
    WD(:,i) = W(:,i);
    HD(i,:) = H(i,:);
end
WS = W(:,r);
HS = H(r,:);

RD = (WD*HD);
RS = (WS*HS);

%Reconstruction de l'image en matrice de tableaux
k = 0;

RID = zeros(nI,pI,qI);
RIS = zeros(nI,pI,qI);
mask = zeros(nI,pI);

for i = 1:nI
    for j = 1:pI
        k = k+1;
        RID(i,j,:) = RD(:,k); 
        RIS(i,j,:) = RS(:,k);
        if norm(RIS(i,j))<30
            mask(i,j) = 1;
        else
            mask(i,j) = 0;
        end
    end
end

CIS = RID.*RIS./255;

%affichage pour les tests

J = CIS+double(I)-RIS;

function s = project(x,L1,L2)
%projeter un vecteur sur les vecteurs à composantes positives ou nulles
%le plus proche au sens des moindres carrés

n = length(x);

s = x+(L1-sum(x))/n;
e = ones(n,1)';
Z = [];
q = 0;

flag = true;

while flag
    m = L1/(n-q)*e;
    m(Z) = 0;
    
    %calcul de alpha
    tmp = s-m;
    c = [sum(tmp.^2) 2*sum(m.*tmp) sum(m.^2)-L2^2];
    delta = c(2)^2-4*c(1)*c(3);
    %r = [(-c(2)-sqrt(delta))/(2*c(1)) (-c(2)+sqrt(delta))/(2*c(1))];
    alpha = (-c(2)+real(sqrt(delta)))/(2*c(1));
        
    s = m+alpha*tmp;
    
    if any(s(:)<0)%si s a des composantes négatives
        %recherche des valeurs négatives
        Z = find(s<=0);
        q = length(Z);
    
        %on annule les composantes negatives de s
        s(Z) = 0;
    
        c = (sum(s)-L1)/(n-q);
        s = s-c;
        s(Z) = 0;
    else
        flag = false;
    end
end



