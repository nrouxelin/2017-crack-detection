function y = chambolle(u,lambda,tol)

iter    = 0;
MAXITER = 500;
err     = 2*tol;

rho = 0.248;

[n, m, l] = size(u);

p1 = zeros(n,m,l);
p2 = zeros(n,m,l);

while iter<=MAXITER && err>=tol
    p1_old = p1;
    p2_old = p2;
    d        = diver(p1,p2);
    [gx, gy] = grad(d-u/lambda);
    
    z1 = p1+rho*gx;
    z2 = p2+rho*gy;
    
    p1 = z1./(max(1.0,sqrt(sum(z1.^2,3))));
    p2 = z2./(max(1.0,sqrt(sum(z2.^2,3))));
    
    err  = max(max(max(max(abs(p1-p1_old))),max(max(abs(p2-p2_old)))));
    iter = iter+1;
end

y = u-diver(p1,p2)*lambda;
end